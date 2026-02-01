import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';

class DisconnectChatSocketUseCase {
  final ChatRepository repo;
  DisconnectChatSocketUseCase(this.repo);

  Future<void> call() => repo.disconnectSocket();
}
