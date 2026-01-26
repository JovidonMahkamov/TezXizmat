import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/customer_create_order_use_case.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/customer_get_all_orders_use_case.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_create_order/customer_create_order_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_state.dart';

class GetCustomerAllOrdersBloc extends Bloc<CustomerOrderEvent, GetCustomerAllOrdersState> {
  final CustomerGetAllOrdersUseCase getAllOrdersUseCase;

  GetCustomerAllOrdersBloc(this.getAllOrdersUseCase) : super(GetCustomerAllOrdersInitial()) {
    on<GetCustomerAllOrdersE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(GetCustomerAllOrdersLoading());
    try {
      final result = await getAllOrdersUseCase();
      emit(GetCustomerAllOrdersSuccess(getCustomerAllOrdersEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(GetCustomerAllOrdersError( message: errorMessage));
    } catch (e) {
      emit(GetCustomerAllOrdersError(message: "Noma’lum xato yuz berdi"));
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