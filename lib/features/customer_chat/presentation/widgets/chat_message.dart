class ChatMessage {
  final String id;
  String text;
  final DateTime createdAt;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.isMe,
  });
}
