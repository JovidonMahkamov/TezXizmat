import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_resend_email_use_case.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_resend_email/customer_resend_email_state.dart';

class CustomerResendEmailBloc extends Bloc<CustomerAuthEvent, CustomerResendEmailState> {
  final CustomerResendEmailUseCase customerResendEmailUseCase;

  CustomerResendEmailBloc(this.customerResendEmailUseCase) : super(CustomerResendEmailInitial()) {
    on<CustomerResendEmail>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerResendEmailLoading());
    try {
      final result = await customerResendEmailUseCase(
        email: event.email,
      );
      emit(CustomerResendEmailSuccess(customerResendEmailEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerResendEmailError( message: errorMessage));
    } catch (e) {
      emit(CustomerResendEmailError(message: "Noma’lum xato yuz berdi"));
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