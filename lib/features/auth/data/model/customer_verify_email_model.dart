
import 'package:tez_xizmat/features/auth/domain/entities/customer_verify_email_entity.dart';

class CustomerVerifyEmailModel extends CustomerVerifyEmailEntity {
  const CustomerVerifyEmailModel({
    required super.message,
    required super.email,
    required super.purpose,
  });
  factory CustomerVerifyEmailModel.fromJson(Map<String, dynamic> json) {
    return CustomerVerifyEmailModel(
      message: json['message'],
      email: json['email'],
      purpose: json['purpose'],
    );
  }
}
