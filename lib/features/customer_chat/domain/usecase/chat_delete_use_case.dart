import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_delete_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';

class ChatDeleteUseCase {
  final ChatRepository repo;
  ChatDeleteUseCase(this.repo);

  Future<ChatDeleteEntity> call({required int roomId}) => repo.deleteChat(roomId: roomId);
}
