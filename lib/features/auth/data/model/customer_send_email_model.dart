
import 'package:tez_xizmat/features/auth/domain/entities/customer_send_email_entity.dart';

class CustomerSendEmailModel extends CustomerSendEmailEntity {
  const CustomerSendEmailModel({
    required super.detail,
    required super.email,
    required super.expires_at,
  });
  factory CustomerSendEmailModel.fromJson(Map<String, dynamic> json) {
    return CustomerSendEmailModel(
      detail: json['detail'],
      email: json['email'],
      expires_at: json['expires_at'],
    );
  }
}
