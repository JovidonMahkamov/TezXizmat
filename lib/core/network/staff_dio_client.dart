import 'dart:async';
import 'package:dio/dio.dart';
import 'package:tez_xizmat/core/network/staff_api_urls.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';

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
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            try {
              final newAccess = await _refreshTokenSafely();
              if (newAccess != null) {
                final opts = e.requestOptions;

                // eski headerni yangilaymiz
                opts.headers['Authorization'] = 'Bearer $newAccess';

                final cloned = await _dio.fetch(opts);
                return handler.resolve(cloned);
              } else {
                // refresh bo‘lmadi -> tokenlarni tozalab, login chiqarish kerak (xohlasang qo‘shamiz)
                // await local.clearAll();
              }
            } catch (_) {}
          }

          return handler.next(e);
        },

      ),
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
