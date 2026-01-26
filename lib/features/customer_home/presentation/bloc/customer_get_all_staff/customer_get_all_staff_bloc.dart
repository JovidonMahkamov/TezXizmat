import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_home/domain/usecase/customer_get_all_staff_use_case.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_state.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_home_event.dart';

class CustomerGetAllStaffBloc extends Bloc<CustomerHomeEvent, CustomerGetAllStaffState> {
  final CustomerGetAllStaffUseCase customerGetAllStaffUseCase;

  CustomerGetAllStaffBloc(this.customerGetAllStaffUseCase) : super(CustomerGetAllStaffInitial()) {
    on<CustomerGetAllStaff>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerGetAllStaffLoading());
    try {
      final result = await customerGetAllStaffUseCase();
      emit(CustomerGetAllStaffSuccess(customerGetAllStaffEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerGetAllStaffError( message: errorMessage));
    } catch (e) {
      emit(CustomerGetAllStaffError(message: "Noma’lum xato yuz berdi"));
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