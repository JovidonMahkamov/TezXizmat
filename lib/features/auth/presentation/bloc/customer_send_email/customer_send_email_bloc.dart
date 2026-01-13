import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_send_email_use_case.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_state.dart';

class CustomerSendEmailBloc extends Bloc<CustomerAuthEvent, CustomerSendEmailState> {
  final CustomerSendEmailUseCase customerSendEmailUseCase;

  CustomerSendEmailBloc(this.customerSendEmailUseCase) : super(CustomerSendEmailInitial()) {
    on<CustomerSendEmail>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerSendEmailLoading());
    try {
      final result = await customerSendEmailUseCase(
        email: event.email,
      );
      emit(CustomerSendEmailSuccess(customerSendEmailEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerSendEmailError( message: errorMessage));
    } catch (e) {
      emit(CustomerSendEmailError(message: "Noma’lum xato yuz berdi"));
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