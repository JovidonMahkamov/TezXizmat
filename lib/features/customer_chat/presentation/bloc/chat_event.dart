import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class GetChatRoomsE extends ChatEvent {
  const GetChatRoomsE();
}
class ChatOpenRoomE extends ChatEvent {
  final int roomId;
  final String accessToken; // ws uchun kerak
  const ChatOpenRoomE({required this.roomId, required this.accessToken});
}

class ChatSendE extends ChatEvent {
  final int roomId;
  final String text;
  final SenderType senderType;

  const ChatSendE({
    required this.roomId,
    required this.text,
    required this.senderType,
  });
}


class ChatDisconnectE extends ChatEvent {
  const ChatDisconnectE();
}

// internal event: ws dan kelgan message
class ChatIncomingE extends ChatEvent {
  final ChatMessageEntity message;
  const ChatIncomingE(this.message);
}
class ChatSocketConnectedE extends ChatEvent {}

class ChatSocketDisconnectedE extends ChatEvent {}
