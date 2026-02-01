import 'dart:async';
import '../entities/chat_message_entity.dart';
import '../entities/chat_room_entity.dart';

abstract class ChatRepository {
  //  REST
  Future<List<ChatRoomEntity>> getRooms();

  Future<List<ChatMessageEntity>> getRoomMessages({
    required int roomId,
  });

  Future<ChatMessageEntity> sendMessageRest({
    required int roomId,
    required String text,
  });

  //  WebSocket
  Future<void> connectSocket({
    required int roomId,
    required String accessToken,
  });

  Future<void> disconnectSocket();

  /// WS dan kelayotgan yangi xabarlar stream’i
  Stream<ChatMessageEntity> socketMessages();

  /// WS orqali yuborish (real-time)
  Future<void> sendMessageSocket({
    required String text,
  });
}
