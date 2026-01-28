import '../../domain/entities/customer_entity.dart';

class GetCustomerModel extends CustomerEntity {
  const GetCustomerModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.fullName,
  });

  factory GetCustomerModel.fromJson(Map<String, dynamic> json) {
    return GetCustomerModel(
      id: json['id'] ?? 0,
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
    );
  }
}
