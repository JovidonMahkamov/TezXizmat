/// chatda yozish uchun kerak bo'ladigan itemlar
class ChatMessageWorker {
  final String id;
  String text;
  final DateTime createdAt;
  final bool isMe;

  ChatMessageWorker({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.isMe,
  });
}
