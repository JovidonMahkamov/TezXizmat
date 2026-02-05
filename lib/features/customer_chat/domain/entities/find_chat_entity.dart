class FindChatEntity {
  final int id;
  final int? orderId;
  final DateTime? createdAt;

  /// Backend hozir "string" qaytaryapti (masalan ism yoki id string)
  final String? customer;
  final String? staff;

  final String? lastMessage;

  /// UI uchun int bo‘lishi kerak
  final int unreadCount;

  const FindChatEntity({
    required this.id,
    required this.unreadCount,
    this.orderId,
    this.createdAt,
    this.customer,
    this.staff,
    this.lastMessage,
  });
}
