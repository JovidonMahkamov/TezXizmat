import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.text,
    required super.senderType,
    required super.createdAt,
  });

  static SenderType _mapSender(String? raw) {
    final v = (raw ?? '').toLowerCase().trim();
    if (v == 'customer') return SenderType.customer;
    if (v == 'staff') return SenderType.staff;
    return SenderType.unknown;
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final parsed = DateTime.tryParse((json['created_at'] ?? '').toString());

    return ChatMessageModel(
      id: (json['id'] ?? 0) as int,
      text: (json['text'] ?? '').toString(),
      senderType: _mapSender(json['sender_type']?.toString()),
      createdAt: (parsed?.toLocal() ?? DateTime.now()),
    );
  }
}