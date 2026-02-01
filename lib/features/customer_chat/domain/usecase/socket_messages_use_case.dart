import 'dart:async';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';

class SocketMessagesUseCase {
  final ChatRepository repo;
  SocketMessagesUseCase(this.repo);

  Stream<ChatMessageEntity> call() => repo.socketMessages();
}
