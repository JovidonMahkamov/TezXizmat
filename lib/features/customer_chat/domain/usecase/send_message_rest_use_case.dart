import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';

class SendMessageRestUseCase {
  final ChatRepository repo;
  SendMessageRestUseCase(this.repo);

  Future<ChatMessageEntity> call({
    required int roomId,
    required String text,
  }) {
    return repo.sendMessageRest(roomId: roomId, text: text);
  }
}
