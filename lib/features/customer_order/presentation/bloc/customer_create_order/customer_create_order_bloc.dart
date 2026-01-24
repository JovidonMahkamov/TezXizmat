import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/customer_create_order_use_case.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_create_order/customer_create_order_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';

class CustomerCreateOrderBloc extends Bloc<CustomerOrderEvent, CustomerCreateOrderState> {
  final CustomerCreateOrderUseCase customerCreateOrderUseCase;

  CustomerCreateOrderBloc(this.customerCreateOrderUseCase) : super(CustomerCreateOrderInitial()) {
    on<CustomerCreateOrder>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerCreateOrderLoading());
    try {
      final result = await customerCreateOrderUseCase(
        staff_id: event.staff_id,
        name: event.name,
        surname: event.surname,
        description: event.description,
        address: event.address,
      );
      emit(CustomerCreateOrderSuccess(customerCreateOrderEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerCreateOrderError( message: errorMessage));
    } catch (e) {
      emit(CustomerCreateOrderError(message: "Noma’lum xato yuz berdi"));
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