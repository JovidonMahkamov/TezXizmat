import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/customer_profile_image_use_case.dart';
import '../customer_profile_event.dart';
import 'customer_profile_image_state.dart';

class CustomerProfileImageBloc extends Bloc<CustomerProfileEvent, CustomerProfileImageState> {
  final CustomerProfileImageUseCase customerProfileImageUseCase;

  CustomerProfileImageBloc(this.customerProfileImageUseCase) : super(CustomerProfileImageInitial()) {
    on<CustomerProfileImageE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CustomerProfileImageLoading());
    try {
      final result = await customerProfileImageUseCase(
          filePath: event.filePath
      );
      emit(CustomerProfileImageSuccess(customerProfileImageEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CustomerProfileImageError( message: errorMessage));
    } catch (e) {
      emit(CustomerProfileImageError(message: "Noma’lum xato yuz berdi"));
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