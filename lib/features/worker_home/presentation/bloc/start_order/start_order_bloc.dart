import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/accept_order_use_case.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/start_order_use_case.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/accept_order/accept_order_state.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/start_order/start_order_state.dart';
import '../worker_home_event.dart';

class StartOrderBloc extends Bloc<WorkerHomeEvent, StartOrderState> {
  final StartOrderUseCase startOrderUseCase;

  StartOrderBloc(this.startOrderUseCase) : super(StartOrderInitial()) {
    on<StartOrderE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(StartOrderLoading());
    try {
      final result = await startOrderUseCase(id: event.id);
      emit(StartOrderSuccess(cancelOrderEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(StartOrderError( message: errorMessage));
    } catch (e) {
      emit(StartOrderError(message: "Noma’lum xato yuz berdi"));
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