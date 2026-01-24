
import 'package:tez_xizmat/features/auth/domain/entities/customer_resend_email_entity.dart';

class CustomerResendEmailModel extends CustomerResendEmailEntity {
  const CustomerResendEmailModel({
    required super.detail,
    required super.expires_at,
  });
  factory CustomerResendEmailModel.fromJson(Map<String, dynamic> json) {
    return CustomerResendEmailModel(
      detail: json['detail'],
      expires_at: json['expires_at'],
    );
  }
}
