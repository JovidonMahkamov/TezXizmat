import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/cancel_order_use_case.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/confirm_completion_use_case.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/cancel_order/cancel_order_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';

class ConfirmCompletionBloc extends Bloc<CustomerOrderEvent, ConfirmCompletionState> {
  final ConfirmCompletionUseCase completionUseCase;

  ConfirmCompletionBloc(this.completionUseCase) : super(ConfirmCompletionInitial()) {
    on<ConfirmCompletionE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(ConfirmCompletionLoading());
    try {
      final result = await completionUseCase(
        id: event.id,
      );
      emit(ConfirmCompletionSuccess(cancelOrderEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(ConfirmCompletionError( message: errorMessage));
    } catch (e) {
      emit(ConfirmCompletionError(message: "Noma’lum xato yuz berdi"));
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