import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/confirm_completion_use_case.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';

class ConfirmCompletionBloc extends Bloc<CustomerOrderEvent, ConfirmCompletionState> {
  final ConfirmCompletionUseCase completionUseCase;

  ConfirmCompletionBloc(this.completionUseCase) : super(ConfirmCompletionInitial()) {
    on<ConfirmCompletionE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(ConfirmCompletionLoading());
    try {
      await completionUseCase(id: event.id,);
      emit(ConfirmCompletionSuccess());
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(ConfirmCompletionError( message: errorMessage));
    } catch (e) {
      emit(ConfirmCompletionError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 403) {
      return "Sizga ruxsat yo‘q (403). Balki staff hali complete qilmagan yoki bu order sizniki emas.";
    } else if (error.response?.statusCode == 400) {
      return "So‘rov noto‘g‘ri (400). Order holatini tekshiring.";
    } else if (error.response?.statusCode == 404) {
      return "Endpoint topilmadi (404). confirm-completion url noto‘g‘ri bo‘lishi mumkin.";
    }

    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }}