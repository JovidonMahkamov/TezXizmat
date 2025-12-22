class ChatItem {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;

  ChatItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
  });
}
