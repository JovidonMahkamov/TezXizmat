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

    // qo'shimcha eventlar (socket status uchun)
    on<ChatSocketConnectedE>(_onSocketConnected);
    on<ChatSocketDisconnectedE>(_onSocketDisconnected);
  }

  // ===== OPEN ROOM =====
  Future<void> _onOpenRoom(
    ChatOpenRoomE e,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(const ChatDetailLoading());

    try {
      // 1) History (REST)
      final history = await getMessages(roomId: e.roomId);

      // 2) UI ready: history ko‘rinadi, socket hali false
      emit(
        ChatDetailReady(
          roomId: e.roomId,
          socketConnected: false,
          messages: history,
        ),
      );
    } catch (err) {
      emit(ChatDetailError(err.toString()));
      return;
    }

    // 3) Socket ulash (history kelgan bo'lsa ham socket yiqilsa UI yiqilmasin)
    try {
      await connectSocket(roomId: e.roomId, accessToken: e.accessToken);

      // 4) stream listen (socketdan keladigan xabarlar)
      await _sub?.cancel();
      _sub = socketStream().listen(
        (msg) => add(ChatIncomingE(msg)),
        onError: (_) => add(ChatSocketDisconnectedE()),
        onDone: () => add(ChatSocketDisconnectedE()),
      );

      add(ChatSocketConnectedE());
    } catch (_) {
      // socket ulanmadi -> UI history bilan turadi, socketConnected false qoladi
      add(ChatSocketDisconnectedE());
    }
  }

  void _onSocketConnected(
    ChatSocketConnectedE e,
    Emitter<ChatDetailState> emit,
  ) {
    final s = state;
    if (s is ChatDetailReady) {
      emit(s.copyWith(socketConnected: true));
    }
  }

  void _onSocketDisconnected(
    ChatSocketDisconnectedE e,
    Emitter<ChatDetailState> emit,
  ) {
    final s = state;
    if (s is ChatDetailReady) {
      emit(s.copyWith(socketConnected: false));
    }
  }

  // ===== INCOMING MESSAGE =====
  void _onIncoming(ChatIncomingE e, Emitter<ChatDetailState> emit) {
    final s = state;
    if (s is! ChatDetailReady) return;

    final incoming = e.message;

    // 1) Agar bu biz yuborgan optimistic xabar bo'lsa -> uni real xabar bilan almashtiramiz
    final idx = s.messages.lastIndexWhere((m) {
      final sameSender = m.senderType == incoming.senderType;
      final sameText = m.text.trim() == incoming.text.trim();
      final isOptimistic = m.id < 0; // optimistic id manfiy
      final isRecent = DateTime.now().difference(m.createdAt).inSeconds < 20;
      return isOptimistic && sameSender && sameText && isRecent;
    });

    if (idx != -1) {
      final updated = List<ChatMessageEntity>.from(s.messages);
      updated[idx] = incoming; // optimistic o'rniga real message
      emit(s.copyWith(messages: updated));
      return;
    }

    // 2) Oddiy duplicate bo'lmasin (real id bo'yicha)
    final exists = s.messages.any((m) => m.id == incoming.id);
    if (exists) return;

    emit(s.copyWith(messages: [...s.messages, incoming]));
  }

  Future<void> _onSend(ChatSendE e, Emitter<ChatDetailState> emit) async {
    final s = state;
    if (s is! ChatDetailReady) return;

    final text = e.text.trim();
    if (text.isEmpty) return;

    // senderType: bu page qaysi rol ekaniga qarab qo'yiladi
    // Agar senga worker page bo'lsa -> staff bo'lishi kerak.
    // Hozircha customer deb qoldirdim, xohlasang pastda "isStaff" yechimni beraman.
    final optimistic = ChatMessageEntity(
      id: -DateTime.now().millisecondsSinceEpoch,
      text: text,
      createdAt: DateTime.now(),
      senderType: e.senderType,
    );

    // 0) Optimistic UI (darhol ko‘rinadi)
    emit(s.copyWith(messages: [...s.messages, optimistic]));

    // 1) WS bilan yuborishga urinib ko‘ramiz
    try {
      await sendSocket(text: text);
      // server WS orqali qaytarib ham berishi mumkin, duplicate bo‘lmasligi uchun
      // incoming’da id bo‘yicha tekshiruv bor
      return;
    } catch (_) {
      // WS ishlamadi -> REST fallback
    }

    // 2) REST fallback
    try {
      final sent = await sendRest(roomId: e.roomId, text: text);

      final now = state;
      if (now is ChatDetailReady) {
        final replaced = now.messages.map((m) {
          if (m.id == optimistic.id) return sent;
          return m;
        }).toList();
        emit(now.copyWith(messages: replaced));
      }
    } catch (_) {
      // REST ham yiqildi -> optimisticni olib tashlaymiz
      final now = state;
      if (now is ChatDetailReady) {
        final cleaned = now.messages
            .where((m) => m.id != optimistic.id)
            .toList();
        emit(now.copyWith(messages: cleaned));
      }
    }
  }

  // ===== DISCONNECT =====
  Future<void> _onDisconnect(
    ChatDisconnectE e,
    Emitter<ChatDetailState> emit,
  ) async {
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
