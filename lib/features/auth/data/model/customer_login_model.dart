
import 'package:tez_xizmat/features/auth/domain/entities/customer_login_entity.dart';

class CustomerLoginModel extends CustomerLoginEntity {
  const CustomerLoginModel({
    required super.refresh, required super.access, required super.email, required super.first_name, required super.last_name, required super.id,
  });
  factory CustomerLoginModel.fromJson(Map<String, dynamic> json) {
    return CustomerLoginModel(
      id: json['id'], refresh: json['refresh'], access: json['access'], email: json['email'], first_name: json['first_name'], last_name: json['last_name'],
    );
  }
}
