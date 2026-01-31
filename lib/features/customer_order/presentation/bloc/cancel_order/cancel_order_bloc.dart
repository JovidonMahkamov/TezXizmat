import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/cancel_order_use_case.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/cancel_order/cancel_order_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';

class CancelOrderBloc extends Bloc<CustomerOrderEvent, CancelOrderState> {
  final CancelOrderUseCase cancelOrderUseCase;

  CancelOrderBloc(this.cancelOrderUseCase) : super(CancelOrderInitial()) {
    on<CancelOrderE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CancelOrderLoading());
    try {
      final result = await cancelOrderUseCase(
        reason: event.reason,
        id: event.id,
      );
      emit(CancelOrderSuccess(cancelOrderEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CancelOrderError( message: errorMessage));
    } catch (e) {
      emit(CancelOrderError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 401 || error.response?.statusCode ==404) {
      return "Login yoki parol noto‘g‘ri.";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }

    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }}