import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_update_profile_entity.dart';

class CustomerUpdateProfileModel extends CustomerUpdateProfileEntity {
  const CustomerUpdateProfileModel({
    required super.email,
    required super.firstName,
    required super.lastName,
  });

  factory CustomerUpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerUpdateProfileModel(
      email: (json['email'] ?? '').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'first_name': firstName, 'last_name': lastName};
  }
}
