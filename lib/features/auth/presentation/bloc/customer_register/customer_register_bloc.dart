import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_register_use_case.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_register/customer_register_state.dart';

class CustomerRegisterBloc extends Bloc<CustomerAuthEvent, CustomerRegisterState> {
   final CustomerRegisterUseCase customerRegisterUseCase;

  CustomerRegisterBloc(this.customerRegisterUseCase) : super(CustomerRegisterInitial()) {
    on<CustomerRegister>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerRegisterLoading());
    try {
      final result = await customerRegisterUseCase(
        email: event.email,
        name: event.name,
        surname: event.surname,
        password: event.password,
        confirm_password: event.confirm_password,

      );
      emit(CustomerRegisterSuccess(customerRegisterEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerRegisterError( message: errorMessage));
    } catch (e) {
      emit(CustomerRegisterError(message: "Noma’lum xato yuz berdi"));
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