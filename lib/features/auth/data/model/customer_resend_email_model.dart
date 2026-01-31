
import 'package:tez_xizmat/features/auth/domain/entities/customer_resend_email_entity.dart';

class CustomerResendEmailModel extends CustomerResendEmailEntity {
  const CustomerResendEmailModel({
    required super.message,
    required super.email,
    required super.expires_in,
    required super.purpose,
  });
  factory CustomerResendEmailModel.fromJson(Map<String, dynamic> json) {
    return CustomerResendEmailModel(
      message: json['message'] ?? "",
      email: json['email'] ?? "",
      expires_in: json['expires_in'] ?? 0,
      purpose: json['purpose'] ?? "",
    );
  }
}
