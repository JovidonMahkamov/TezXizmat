
import 'package:tez_xizmat/features/worker_home/domain/entities/get_staff_orders_entity.dart';

class GetStaffOrdersModel extends GetStaffOrdersEntity {
  const GetStaffOrdersModel({
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

  factory GetStaffOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetStaffOrdersModel(
      id: json['id'] ?? 0,
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profession: json['profession']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      skills: json['skills']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      freeTime: json['free_time']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isActive: json['is_active'] ?? false,
      fullName: json['full_name']?.toString() ?? '',
    );
  }
}
