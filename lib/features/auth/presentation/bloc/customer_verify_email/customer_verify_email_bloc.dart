import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_verify_email_use_case.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_verify_email/customer_verify_email_state.dart';

class CustomerVerifyEmailBloc extends Bloc<CustomerAuthEvent, CustomerVerifyEmailState> {
  final CustomerVerifyEmailUseCase customerVerifyEmailUseCase;

  CustomerVerifyEmailBloc(this.customerVerifyEmailUseCase) : super(CustomerVerifyEmailInitial()) {
    on<CustomerVerifyEmail>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerVerifyEmailLoading());
    try {
      final result = await customerVerifyEmailUseCase(
        email: event.email,
        password: event.password,
        purpose: event.purpose,

      );
      emit(CustomerVerifyEmailSuccess(customerVerifyEmailEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerVerifyEmailError( message: errorMessage));
    } catch (e) {
      emit(CustomerVerifyEmailError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return "Kiritilgan kod xato";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }

    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }}