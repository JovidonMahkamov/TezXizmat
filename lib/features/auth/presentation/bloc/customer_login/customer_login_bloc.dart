import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_login_use_case.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_login/customer_login_state.dart';

class CustomerLoginBloc extends Bloc<CustomerAuthEvent, CustomerLoginState> {
  final CustomerLoginUseCase customerLoginUseCase;

  CustomerLoginBloc(this.customerLoginUseCase) : super(CustomerLoginInitial()) {
    on<CustomerLogin>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerLoginLoading());
    try {
      final result = await customerLoginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(CustomerLoginSuccess(customerLoginEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerLoginError( message: errorMessage));
    } catch (e) {
      emit(CustomerLoginError(message: "Noma’lum xato yuz berdi"));
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