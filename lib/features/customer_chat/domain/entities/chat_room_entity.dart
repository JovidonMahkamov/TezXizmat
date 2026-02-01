import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_customer_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_staff_entity.dart';

class ChatRoomEntity {
  final int id;
  final int orderId;
  final DateTime createdAt;
  final ChatUserEntity customer;
  final ChatStaffEntity staff;

  const ChatRoomEntity({
    required this.id,
    required this.orderId,
    required this.createdAt,
    required this.customer,
    required this.staff,
  });
}




