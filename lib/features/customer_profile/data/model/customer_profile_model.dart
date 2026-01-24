import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_profile_entity.dart';

class CustomerProfileModel extends CustomerProfileEntity {
  const CustomerProfileModel({
    required super.email,
    required super.firstName,
    required super.lastName,
  });

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      email: (json['email'] ?? '').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'first_name': firstName, 'last_name': lastName};
  }
}
