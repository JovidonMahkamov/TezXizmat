import '../../domain/entities/order_staff_entity.dart';

class OrderStaffModel extends OrderStaffEntity {
  const OrderStaffModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.image,
    required super.profession,
    required super.description,
    required super.skillsText,
    required super.priceText,
    required super.freeTimeText,
  });

  factory OrderStaffModel.fromJson(Map<String, dynamic> json) {
    return OrderStaffModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      image: json['image'] ?? '',
      profession: json['profession'] ?? '',
      description: json['description'] ?? '',
      skillsText: json['skills_text'] ?? '',
      priceText: json['price_text'] ?? '',
      freeTimeText: json['free_time_text'] ?? '',
    );
  }
}