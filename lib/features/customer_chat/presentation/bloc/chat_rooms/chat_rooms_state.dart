import '../../../domain/entities/chat_room_entity.dart';

abstract class ChatRoomsState {
  const ChatRoomsState();
}

class ChatRoomsInitial extends ChatRoomsState {
  const ChatRoomsInitial();
}

class ChatRoomsLoading extends ChatRoomsState {
  const ChatRoomsLoading();
}

class ChatRoomsSuccess extends ChatRoomsState {
  final List<ChatRoomEntity> rooms;
  const ChatRoomsSuccess(this.rooms);
}

class ChatRoomsError extends ChatRoomsState {
  final String message;
  const ChatRoomsError(this.message);
}
