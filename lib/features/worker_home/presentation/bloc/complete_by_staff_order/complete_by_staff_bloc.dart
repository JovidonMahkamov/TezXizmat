import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/complete_by_staff_use_case.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/complete_by_staff_order/complete_by_staff_state.dart';
import '../worker_home_event.dart';

class CompleteByStaffBloc extends Bloc<WorkerHomeEvent, CompleteByStaffState> {
  final CompleteByStaffUseCase completeByStaffUseCase;

  CompleteByStaffBloc(this.completeByStaffUseCase) : super(CompleteByStaffInitial()) {
    on<CompleteOrderE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(CompleteByStaffLoading());
    try {
      final result = await completeByStaffUseCase(id: event.id);
      emit(CompleteByStaffSuccess(cancelOrderEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(CompleteByStaffError( message: errorMessage));
    } catch (e) {
      emit(CompleteByStaffError(message: "Noma’lum xato yuz berdi"));
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