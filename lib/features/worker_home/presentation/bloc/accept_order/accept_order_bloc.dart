import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/accept_order_use_case.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/accept_order/accept_order_state.dart';
import '../worker_home_event.dart';

class AcceptOrderBloc extends Bloc<WorkerHomeEvent, AcceptOrderState> {
  final AcceptOrderUseCase acceptOrderUseCase;

  AcceptOrderBloc(this.acceptOrderUseCase) : super(AcceptOrderInitial()) {
    on<AcceptOrderE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(AcceptOrderLoading());
    try {
      final result = await acceptOrderUseCase(id: event.id);
      emit(AcceptOrderSuccess(cancelOrderEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(AcceptOrderError( message: errorMessage));
    } catch (e) {
      emit(AcceptOrderError(message: "Noma’lum xato yuz berdi"));
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