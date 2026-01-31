import 'package:tez_xizmat/features/customer_home/domain/entities/customer_get_all_staff_entity.dart';

class CustomerGetAllStaffModel extends CustomerGetAllStaffEntity {
  const CustomerGetAllStaffModel({

    required super.image,
    required super.first_name,
    required super.last_name,
    required super.id,

    required super.profession,

  });

  factory CustomerGetAllStaffModel.fromJson(Map<String, dynamic> json) {
    return CustomerGetAllStaffModel(
      id: json['id'] ?? 0,
      profession: json['profession'] ?? "",
      first_name: json['first_name'] ?? "",
      last_name: json['last_name'] ?? "",
      image: json['image'] as String?,
    );
  }
}
