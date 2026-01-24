
import 'package:tez_xizmat/features/auth/domain/entities/customer_reset_password_entity.dart';

class CustomerResetPasswordModel extends CustomerResetPasswordEntity {
  const CustomerResetPasswordModel({
    required super.message,
  });
  factory CustomerResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return CustomerResetPasswordModel(
      message: json['message'],

    );
  }
}
