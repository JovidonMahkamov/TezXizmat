
import 'package:tez_xizmat/features/auth/domain/entities/customer_register_entity.dart';

class CustomerRegisterModel extends CustomerRegisterEntity {
  const CustomerRegisterModel({
    required super.detail,
  });
  factory CustomerRegisterModel.fromJson(Map<String, dynamic> json) {
    return CustomerRegisterModel(
      detail: json['detail'],
    );
  }
}
