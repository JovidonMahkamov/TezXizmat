
import 'package:tez_xizmat/features/customer_chat/domain/entities/find_chat_entity.dart';

class FindChatModel extends FindChatEntity {
  const FindChatModel({
    required super.id,
    required super.unreadCount,
    super.orderId,
    super.createdAt,
    super.customer,
    super.staff,
    super.lastMessage,
  });

  factory FindChatModel.fromJson(Map<String, dynamic> json) {
    return FindChatModel(
      id: _asInt(json['id']),
      orderId: _asNullableInt(json['order_id']),
      createdAt: _asNullableDate(json['created_at']),
      customer: _asNullableString(json['customer']),
      staff: _asNullableString(json['staff']),
      lastMessage: _asNullableString(json['last_message']),
      unreadCount: _asInt(json['unreaded_message_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'created_at': createdAt?.toUtc().toIso8601String(),
      'customer': customer,
      'staff': staff,
      'last_message': lastMessage,
      'unreaded_message_count': unreadCount,
    };
  }
}

/// ---- helpers ----

int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v.trim()) ?? 0;
  return 0;
}

int? _asNullableInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v.trim());
  return null;
}

String? _asNullableString(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  return v.toString();
}

DateTime? _asNullableDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}
