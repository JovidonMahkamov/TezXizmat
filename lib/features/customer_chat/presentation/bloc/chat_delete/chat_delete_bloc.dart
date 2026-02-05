import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/chat_delete_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_delete/chat_delete_state.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';

class ChatDeleteBloc extends Bloc<ChatEvent, ChatDeleteState> {
  final ChatDeleteUseCase chatDeleteUseCase;

  ChatDeleteBloc(this.chatDeleteUseCase) : super(ChatDeleteInitial()) {
    on<DeleteChatE>(_onDeleteOne);     //  bitta room
    on<DeleteChatsE>(_onDeleteMany);   //  ko‘p room
  }

  Future<void> _onDeleteOne(DeleteChatE event, Emitter<ChatDeleteState> emit) async {
    emit(ChatDeleteLoading());
    try {
      await chatDeleteUseCase(roomId: event.roomId); //  int ketyapti
      emit(const ChatDeleteSuccess(deletedCount: 1));
    } on DioException catch (e) {
      emit(ChatDeleteError(message: _mapDioErrorToMessage(e)));
    } catch (_) {
      emit(const ChatDeleteError(message: "Noma’lum xato yuz berdi"));
    }
  }

  Future<void> _onDeleteMany(DeleteChatsE event, Emitter<ChatDeleteState> emit) async {
    emit(ChatDeleteLoading());
    try {
      for (final id in event.roomIds) {
        await chatDeleteUseCase(roomId: id); //  har safar int
      }
      emit(ChatDeleteSuccess(deletedCount: event.roomIds.length));
    } on DioException catch (e) {
      emit(ChatDeleteError(message: _mapDioErrorToMessage(e)));
    } catch (_) {
      emit(const ChatDeleteError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown && error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return "So‘rov xato (400).";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }
    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }
}
