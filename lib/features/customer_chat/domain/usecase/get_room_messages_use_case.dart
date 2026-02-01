import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetRoomMessagesUseCase {
  final ChatRepository repo;
  GetRoomMessagesUseCase(this.repo);

  Future<List<ChatMessageEntity>> call({required int roomId}) {
    return repo.getRoomMessages(roomId: roomId);
  }
}
