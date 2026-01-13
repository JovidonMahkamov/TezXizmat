
import 'package:tez_xizmat/features/auth/domain/entities/customer_verify_email_entity.dart';

class CustomerVerifyEmailModel extends CustomerVerifyEmailEntity {
  const CustomerVerifyEmailModel({
    required super.detail,
  });
  factory CustomerVerifyEmailModel.fromJson(Map<String, dynamic> json) {
    return CustomerVerifyEmailModel(
      detail: json['detail'],
    );
  }
}
