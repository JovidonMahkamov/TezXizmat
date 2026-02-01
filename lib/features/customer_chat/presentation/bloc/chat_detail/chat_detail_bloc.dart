import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/connect_chat_socket_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/disconnect_chat_socket_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/get_room_messages_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/send_message_rest_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/send_message_socket_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/socket_messages_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';
import 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatEvent, ChatDetailState> {
  final GetRoomMessagesUseCase getMessages;
  final ConnectChatSocketUseCase connectSocket;
  final DisconnectChatSocketUseCase disconnectSocket;
  final SocketMessagesUseCase socketStream;
  final SendMessageSocketUseCase sendSocket;
  final SendMessageRestUseCase sendRest;

  StreamSubscription<ChatMessageEntity>? _sub;

  ChatDetailBloc({
    required this.getMessages,
    required this.connectSocket,
    required this.disconnectSocket,
    required this.socketStream,
    required this.sendSocket,
    required this.sendRest,
  }) : super(const ChatDetailInitial()) {
    on<ChatOpenRoomE>(_onOpenRoom);
    on<ChatIncomingE>(_onIncoming);
    on<ChatSendE>(_onSend);
    on<ChatDisconnectE>(_onDisconnect);
  }

  Future<void> _onOpenRoom(ChatOpenRoomE e, Emitter<ChatDetailState> emit) async {
    emit(const ChatDetailLoading());

    try {
      // 1) history
      final history = await getMessages(roomId: e.roomId);

      // 2) ready state
      emit(ChatDetailReady(
        roomId: e.roomId,
        socketConnected: false,
        messages: history,
      ));

      // 3) ws connect
      await connectSocket(roomId: e.roomId, accessToken: e.accessToken);

      // 4) stream listen (yangi kelgan xabarlar)
      await _sub?.cancel();
      _sub = socketStream().listen(
            (msg) => add(ChatIncomingE(msg)),
        onError: (err) {
          // socket error bo‘lsa state errorga tushirmaymiz, faqat flagni o‘chirib qo‘yamiz
          final s = state;
          if (s is ChatDetailReady) {
            emit(s.copyWith(socketConnected: false));
          }
        },
      );

      // connected flag
      final s = state;
      if (s is ChatDetailReady) {
        emit(s.copyWith(socketConnected: true));
      }
    } catch (err) {
      emit(ChatDetailError(err.toString()));
    }
  }

  void _onIncoming(ChatIncomingE e, Emitter<ChatDetailState> emit) {
    final s = state;
    if (s is! ChatDetailReady) return;

    // duplicate bo‘lib qolmasin (id bo‘yicha)
    final exists = s.messages.any((m) => m.id == e.message.id);
    if (exists) return;

    final updated = List<ChatMessageEntity>.from(s.messages)..add(e.message);
    emit(s.copyWith(messages: updated));
  }

  Future<void> _onSend(ChatSendE e, Emitter<ChatDetailState> emit) async {
    final s = state;
    if (s is! ChatDetailReady) return;

    final text = e.text.trim();
    if (text.isEmpty) return;

    // 1) avval WS orqali yuboramiz
    try {
      await sendSocket(text: text);
    } catch (_) {
      // WS yuborish ishlamasa REST fallback
      try {
        final sent = await sendRest(roomId: e.roomId, text: text);
        // REST response qaytargan message’ni listga qo‘shib qo‘yamiz
        final updated = List<ChatMessageEntity>.from(s.messages)..add(sent);
        emit(s.copyWith(messages: updated));
      } catch (err) {
        // xohlasang error snack uchun state saqlab qo‘yish mumkin
      }
    }
  }

  Future<void> _onDisconnect(ChatDisconnectE e, Emitter<ChatDetailState> emit) async {
    await _sub?.cancel();
    _sub = null;
    await disconnectSocket();
    final s = state;
    if (s is ChatDetailReady) {
      emit(s.copyWith(socketConnected: false));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await disconnectSocket();
    return super.close();
  }
}
