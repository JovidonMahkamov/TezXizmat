enum SenderType { customer, staff, unknown }

class ChatMessageEntity {
  final int id;
  final String text;
  final SenderType senderType;
  final DateTime createdAt;

  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.senderType,
    required this.createdAt,
  });
}
