
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';

abstract class ChatDetailState {
  const ChatDetailState();
}

class ChatDetailInitial extends ChatDetailState {
  const ChatDetailInitial();
}

class ChatDetailLoading extends ChatDetailState {
  const ChatDetailLoading();
}

class ChatDetailReady extends ChatDetailState {
  final int roomId;
  final bool socketConnected;
  final List<ChatMessageEntity> messages;

  const ChatDetailReady({
    required this.roomId,
    required this.socketConnected,
    required this.messages,
  });

  ChatDetailReady copyWith({
    bool? socketConnected,
    List<ChatMessageEntity>? messages,
  }) {
    return ChatDetailReady(
      roomId: roomId,
      socketConnected: socketConnected ?? this.socketConnected,
      messages: messages ?? this.messages,
    );
  }
}

class ChatDetailError extends ChatDetailState {
  final String message;
  const ChatDetailError(this.message);
}
