import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_customer_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_staff_entity.dart';
import '../../domain/entities/chat_room_entity.dart';

class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.orderId,
    required super.createdAt,
    required super.customer,
    required super.staff,
    required super.lastMessage,
    required super.unreadedMessageCount,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final parsed = DateTime.tryParse((json['created_at'] ?? '').toString());
    return ChatRoomModel(
      id: (json['id'] ?? 0) as int,
      orderId: (json['order_id'] ?? 0) as int,
      lastMessage: (json['last_message'] ?? '').toString(),
      unreadedMessageCount: (json['unreaded_message_count'] ?? '').toString(),
      createdAt: (parsed?.toLocal() ?? DateTime.now()),
      customer: ChatUserEntity(
        id: (json['customer']?['id'] ?? 0) as int,
        firstName: (json['customer']?['first_name'] ?? '').toString(),
        lastName: (json['customer']?['last_name'] ?? '').toString(),
        image: (json['customer']?['image'])?.toString(),
      ),
      staff: ChatStaffEntity(
        id: (json['staff']?['id'] ?? 0) as int,
        firstName: (json['staff']?['first_name'] ?? '').toString(),
        lastName: (json['staff']?['last_name'] ?? '').toString(),
        image: (json['staff']?['image'])?.toString(),
        profession: (json['staff']?['profession'] ?? '').toString(),
      ),
    );
  }
}