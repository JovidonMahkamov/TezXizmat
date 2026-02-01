import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';

class SendMessageSocketUseCase {
  final ChatRepository repo;
  SendMessageSocketUseCase(this.repo);

  Future<void> call({required String text}) {
    return repo.sendMessageSocket(text: text);
  }
}
