import 'package:tez_xizmat/features/customer_order/domain/entities/order_staff_entity.dart';

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
      id: (json['id'] ?? 0) as int,
      firstName: (json['first_name'] ?? '') as String,
      lastName: (json['last_name'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      profession: (json['profession'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      skillsText: (json['skills_text'] ?? '') as String,
      priceText: (json['price_text'] ?? '') as String,
      freeTimeText: (json['free_time_text'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'image': image,
      'profession': profession,
      'description': description,
      'skills_text': skillsText,
      'price_text': priceText,
      'free_time_text': freeTimeText,
    };
  }
}
