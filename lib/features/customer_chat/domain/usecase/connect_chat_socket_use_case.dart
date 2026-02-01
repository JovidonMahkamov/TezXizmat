import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';

class ConnectChatSocketUseCase {
  final ChatRepository repo;
  ConnectChatSocketUseCase(this.repo);

  Future<void> call({
    required int roomId,
    required String accessToken,
  }) {
    return repo.connectSocket(roomId: roomId, accessToken: accessToken);
  }
}
