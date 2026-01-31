
import 'package:tez_xizmat/features/auth/domain/entities/customer_send_email_entity.dart';

class CustomerSendEmailModel extends CustomerSendEmailEntity {
  const CustomerSendEmailModel({
    required super.message,
    required super.email,
    required super.purpose,
    required super.expires_in,
  });
  factory CustomerSendEmailModel.fromJson(Map<String, dynamic> json) {
    return CustomerSendEmailModel(
      message: json['message'],
      email: json['email'],
      purpose: json['purpose'],
      expires_in: json['expires_in'],
    );
  }
}
