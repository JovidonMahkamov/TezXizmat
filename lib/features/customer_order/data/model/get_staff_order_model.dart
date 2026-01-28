import 'package:tez_xizmat/features/customer_order/domain/entities/get_staff_order_entity.dart';

class GetOrderStaffModel extends GetStaffOrderEntity {
  GetOrderStaffModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.profession,
    required super.description,
    required super.skills,
    required super.price,
    required super.freeTime,
    required super.image,
    required super.isActive,
    required super.fullName,
  });

  factory GetOrderStaffModel.fromJson(Map<String, dynamic> json) {
    return GetOrderStaffModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      profession: json['profession'],
      description: json['description'],
      skills: json['skills'],
      price: json['price'],
      freeTime: json['free_time'],
      image: json['image'],
      isActive: json['is_active'],
      fullName: json['full_name'],
    );
  }
}