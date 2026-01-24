import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/reset_password_use_case.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_reset_password/customer_reset_password_state.dart';

class CustomerResetPasswordBloc extends Bloc<CustomerAuthEvent, CustomerResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;

  CustomerResetPasswordBloc(this.resetPasswordUseCase) : super(CustomerResetPasswordInitial()) {
    on<CustomerResetPassword>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerResetPasswordLoading());
    try {
      final result = await resetPasswordUseCase(
        email: event.email,
        password: event.password,
        confirm_password: event.confirm_password,

      );
      emit(CustomerResetPasswordSuccess(customerResetPasswordEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerResetPasswordError( message: errorMessage));
    } catch (e) {
      emit(CustomerResetPasswordError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return "Kiritilgan email tasdiqlanmagan";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }

    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }}