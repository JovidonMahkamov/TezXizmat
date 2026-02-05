import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/get_staff_orders_use_case.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/get_staff_orders/get_staff_orders_state.dart';

import '../worker_home_event.dart';

class GetStaffOrdersBloc extends Bloc<WorkerHomeEvent, GetStaffOrdersState> {
  final GetStaffOrdersUseCase getStaffOrdersUseCase;

  GetStaffOrdersBloc(this.getStaffOrdersUseCase)
      : super(GetStaffOrdersInitial()) {
    on<GetStaffOrdersE>(onLogInUser);
  }

  Future<void> onLogInUser(GetStaffOrdersE event, Emitter<GetStaffOrdersState> emit) async {
    if (!event.silent) {
      emit(GetStaffOrdersLoading());
    }

    try {
      final result = await getStaffOrdersUseCase();
      emit(GetStaffOrdersSuccess(putOrdersStateEntity: result));
    } on DioException catch (e) {
      final errorMessage = _mapDioErrorToMessage(e);
      if (!event.silent) {
        emit(GetStaffOrdersError(message: errorMessage));
      }
    } catch (e) {
      if (!event.silent) {
        emit(GetStaffOrdersError(message: "Noma’lum xato yuz berdi"));
      }
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown && error.error is SocketException) {
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
  }
}
