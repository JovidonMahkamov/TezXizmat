import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/domain/usecase/customer_profile_use_case.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_event.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_state.dart';

class CustomerProfileBloc extends Bloc<CustomerProfileEvent, CustomerProfileState> {
  final CustomerProfileUseCase customerProfileUseCase;

  CustomerProfileBloc(this.customerProfileUseCase) : super(CustomerProfileInitial()) {
    on<CustomerProfileE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerProfileLoading());
    try {
      final result = await customerProfileUseCase();
      emit(CustomerProfileSuccess(customerProfileEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerProfileError( message: errorMessage));
    } catch (e) {
      emit(CustomerProfileError(message: "Noma’lum xato yuz berdi"));
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