import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/domain/usecase/customer_update_profile_use_case.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_event.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/update_profile_bloc/customer_update_profile_state.dart';

class CustomerUpdateProfileBloc extends Bloc<CustomerProfileEvent, CustomerUpdateProfileState> {
  final CustomerUpdateProfileUseCase customerUpdateProfileUseCase;

  CustomerUpdateProfileBloc(this.customerUpdateProfileUseCase) : super(CustomerUpdateProfileInitial()) {
    on<CustomerUpdateProfileE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerUpdateProfileLoading());
    try {
      final result = await customerUpdateProfileUseCase(
        name: event.name,
        surname: event.surname,);
      emit(CustomerUpdateProfileSuccess(customerUpdateProfileEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerUpdateProfileError( message: errorMessage));
    } catch (e) {
      emit(CustomerUpdateProfileError(message: "Noma’lum xato yuz berdi"));
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