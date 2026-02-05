import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/delete_order_use_case.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/delete_order/delete_order_state.dart';

class DeleteOrderBloc extends Bloc<CustomerOrderEvent, DeleteOrderState> {
  final OrderDeleteUseCase orderDeleteUseCase;

  DeleteOrderBloc(this.orderDeleteUseCase) : super(DeleteOrderInitial()) {
    on<DeleteOrderE>(_onDeleteOne);
    on<DeleteOrdersE>(_onDeleteMany);
  }

  Future<void> _onDeleteOne(DeleteOrderE event, Emitter<DeleteOrderState> emit) async {
    emit(DeleteOrderLoading());
    try {
      final result = await orderDeleteUseCase(id: event.id);
      emit(DeleteOrderSuccess(deleteOrderEntity: result));
    } on DioException catch (e) {
      emit(DeleteOrderError(message: _mapDioErrorToMessage(e)));
    } catch (e) {
      emit(DeleteOrderError(message: e.toString())); // debug uchun yaxshi
    }
  }

  Future<void> _onDeleteMany(DeleteOrdersE event, Emitter<DeleteOrderState> emit) async {
    emit(DeleteOrderLoading());
    try {
      // ketma-ket o'chiramiz
      for (final id in event.ids) {
        await orderDeleteUseCase(id: id);
      }

      // Multi delete success: bitta “fake” result qaytaramiz
      // (chunki state DeleteOrderSuccess DeleteOrderEntity kutyapti)
      final fake = await orderDeleteUseCase(id: event.ids.first);

      emit(DeleteOrderSuccess(deleteOrderEntity: fake));
    } on DioException catch (e) {
      emit(DeleteOrderError(message: _mapDioErrorToMessage(e)));
    } catch (e) {
      emit(DeleteOrderError(message: e.toString()));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown && error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    }

    final code = error.response?.statusCode;

    if (code == 401) return "Avtorizatsiya xatosi. Qayta login qiling.";
    if (code == 403) return "Ruxsat yo‘q (403).";
    if (code == 404) return "Order topilmadi (404).";
    if (code == 400) return "So‘rov xato (400).";

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    }

    if (code == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }

    return error.response?.data?.toString() ??
        "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }
}
