import 'dart:async';
import 'package:dio/dio.dart';
import 'package:tez_xizmat/core/network/staff_api_urls.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';

import '../navigation/app_navigator.dart';
import '../routes/route_names.dart';

class StaffDioClient {
  final Dio _dio;
  final AuthLocalDataSource local;

  bool _isRefreshing = false;
  final List<void Function(String token)> _refreshQueue = [];


  StaffDioClient({required this.local})
      : _dio = Dio(
    BaseOptions(
      baseUrl: StaffApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  ) {
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: true, error: true),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Refresh endpointga Authorization qo‘shmaymiz
          final isRefreshCall = options.path.contains('token/refresh');

          if (!isRefreshCall) {
            final access = local.getAccessToken();
            if (access != null && access.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $access';
            }
          } else {
            // ehtiyot uchun (agar oldindan qo‘shilgan bo‘lsa)
            options.headers.remove('Authorization');
          }

          return handler.next(options);
        },
        onError: (e, handler) async {
          final isRefreshCall = e.requestOptions.path.contains('token/refresh');

          // Refresh so‘rovi o‘zi yiqilsa, yana refreshga urunmaymiz
          if (isRefreshCall) {
            return handler.next(e);
          }

          // 401 yoki ba'zan 403 ham bo'lishi mumkin
          if (_looksLikeTokenError(e)) {
            try {
              final newAccess = await _refreshTokenSafely();

              if (newAccess != null && newAccess.isNotEmpty) {
                final opts = e.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newAccess';
                final cloned = await _dio.fetch(opts);
                return handler.resolve(cloned);
              } else {
                await _forceLogout();
                return handler.next(e);
              }
            } catch (_) {
              await _forceLogout();
              return handler.next(e);
            }
          }

          return handler.next(e);
        },

      ),
    );
  }

  bool _looksLikeTokenError(DioException e) {
    final code = e.response?.statusCode;

    // Sizda token eskirganda 400 qaytayapti
    if (code == 400 || code == 401 || code == 403) {
      final data = e.response?.data;
      final text = (data is String) ? data : data?.toString() ?? '';
      final lower = text.toLowerCase();

      return lower.contains('token') ||
          lower.contains('expired') ||
          lower.contains('not valid') ||
          lower.contains('invalid') ||
          lower.contains('unauthorized') ||
          lower.contains('token_not_valid');
    }

    return false;
  }

  Future<void> _forceLogout() async {
    await local.clearAll();

    // stackni tozalab, boshidan login oqimiga qaytaramiz
    appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      RouteNames.carousel, // xohlasang RouteNames.customerLogin qilasan
          (route) => false,
    );
  }


  Future<String?> _refreshTokenSafely() async {
    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshQueue.add((token) => completer.complete(token));
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final refresh = local.getRefreshToken();
      if (refresh == null || refresh.isEmpty) {
        // queue kutib qolmasin
        for (final cb in _refreshQueue) cb('');
        _refreshQueue.clear();
        return null;
      }

      final isStaff = (local.getRole() ?? 'customer') == 'staff';
      final refreshUrl = isStaff ? StaffApiUrls.refreshStaff : StaffApiUrls.refreshCustomer;

      // Refresh so‘roviga Authorization qo‘shilmasin
      final resp = await _dio.post(
        refreshUrl,
        data: {'refresh': refresh},
        options: Options(headers: {'Authorization': null}),
      );

      final newAccess = resp.data['access'] as String?;

      if (newAccess != null && newAccess.isNotEmpty) {
        await local.saveAccessToken(newAccess);

        for (final cb in _refreshQueue) {
          cb(newAccess);
        }
        _refreshQueue.clear();

        return newAccess;
      }

      // refresh bo‘lmadi -> queue tugasin
      for (final cb in _refreshQueue) cb('');
      _refreshQueue.clear();

      return null;
    } finally {
      _isRefreshing = false;
    }
  }



  Future<Response> get(String path, {Map<String, dynamic>? queryParams, Options? options}) =>
      _dio.get(path, queryParameters: queryParams, options: options);

  Future<Response> post(String path, {dynamic data, Options? options}) =>
      _dio.post(path, data: data, options: options);

  Future<Response> put(String path, {dynamic data, Options? options}) =>
      _dio.put(path, data: data, options: options);

  Future<Response> patch(String path, {dynamic data, Options? options}) =>
      _dio.patch(path, data: data, options: options);

  Future<Response> delete(String path, {Map<String, dynamic>? queryParams, Options? options}) =>
      _dio.delete(path, queryParameters: queryParams, options: options);

}
