import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/put_orders_state_use_case.dart';
import '../../../domain/usecase/staff_order_action.dart';
import '../worker_home_event.dart';
import 'put_orders_state.dart';

class PutStaffOrderBloc extends Bloc<WorkerHomeEvent, PutOrdersState> {
  final PutOrdersStateUseCase putOrdersStateUseCase;

  PutStaffOrderBloc({required this.putOrdersStateUseCase})
      : super(PutOrdersStateInitial()) {
    on<AcceptStaffOrderE>(_onAccept);
    on<CancelStaffOrderE>(_onCancel);
    on<CompleteStaffOrderE>(_onComplete);
    on<StartStaffOrderE>(_onStart);
  }

  Future<void> _onAccept(AcceptStaffOrderE event, Emitter<PutOrdersState> emit) async {
    emit(PutOrdersStateLoading());
    try {
      final updated = await putOrdersStateUseCase(
        orderId: event.id,
        action: StaffOrderAction.accept,
      );
      emit(PutOrdersStateSuccess(putOrdersStateEntity: updated));
    } on DioException catch (e) {
      emit(PutOrdersStateError(message: _mapDioErrorToMessage(e)));
    } catch (_) {
      emit(const PutOrdersStateError(message: "Noma’lum xato yuz berdi"));
    }
  }

  Future<void> _onCancel(CancelStaffOrderE event, Emitter<PutOrdersState> emit) async {
    emit(PutOrdersStateLoading());
    try {
      final updated = await putOrdersStateUseCase(
        orderId: event.id,
        action: StaffOrderAction.cancel,
      );
      emit(PutOrdersStateSuccess(putOrdersStateEntity: updated));
    } on DioException catch (e) {
      emit(PutOrdersStateError(message: _mapDioErrorToMessage(e)));
    } catch (_) {
      emit(const PutOrdersStateError(message: "Noma’lum xato yuz berdi"));
    }
  }

  Future<void> _onComplete(CompleteStaffOrderE event, Emitter<PutOrdersState> emit) async {
    emit(PutOrdersStateLoading());
    try {
      final updated = await putOrdersStateUseCase(
        orderId: event.id,
        action: StaffOrderAction.complete,
      );
      emit(PutOrdersStateSuccess(putOrdersStateEntity: updated));
    } on DioException catch (e) {
      emit(PutOrdersStateError(message: _mapDioErrorToMessage(e)));
    } catch (_) {
      emit(const PutOrdersStateError(message: "Noma’lum xato yuz berdi"));
    }
  }

  Future<void> _onStart(StartStaffOrderE event, Emitter<PutOrdersState> emit) async {
    emit(PutOrdersStateLoading());
    try {
      final updated = await putOrdersStateUseCase(
        orderId: event.id,
        action: StaffOrderAction.pending,
      );
      emit(PutOrdersStateSuccess(putOrdersStateEntity: updated));
    } on DioException catch (e) {
      emit(PutOrdersStateError(message: _mapDioErrorToMessage(e)));
    } catch (_) {
      emit(const PutOrdersStateError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown && error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return "So‘rov noto‘g‘ri (400).";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }
    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }
}