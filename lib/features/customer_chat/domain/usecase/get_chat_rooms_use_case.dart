import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_room_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';

class GetChatRoomsUseCase {
  final ChatRepository repo;
  GetChatRoomsUseCase(this.repo);

  Future<List<ChatRoomEntity>> call() => repo.getRooms();
}
