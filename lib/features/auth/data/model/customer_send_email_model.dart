
import 'package:tez_xizmat/features/auth/domain/entities/customer_send_email_entity.dart';

class CustomerSendEmailModel extends CustomerSendEmailEntity {
  const CustomerSendEmailModel({
    required super.detail,
  });
  factory CustomerSendEmailModel.fromJson(Map<String, dynamic> json) {
    return CustomerSendEmailModel(
      detail: json['detail'],
    );
  }
}
