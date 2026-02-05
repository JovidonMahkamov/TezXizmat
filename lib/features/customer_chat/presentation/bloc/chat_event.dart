import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class GetChatRoomsE extends ChatEvent {
  final bool silent;
  const GetChatRoomsE({this.silent = false});
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

class FindChatCustomerE extends ChatEvent {
  final int staffId;
  final int? orderId;

  const FindChatCustomerE({
    required this.staffId,
    this.orderId,
  }); }
class FindChatStaffE extends ChatEvent {
  final int customerId;
  final int? orderId; // hozir backend 0 qilyapti, keyin kerak bo‘lishi mumkin

  const FindChatStaffE({
    required this.customerId,
    this.orderId,
  });}

class DeleteChatE extends ChatEvent {
  final int roomId;
  const DeleteChatE({required this.roomId});
}

class DeleteChatsE extends ChatEvent {
  final List<int> roomIds;
  const DeleteChatsE({required this.roomIds});
}

