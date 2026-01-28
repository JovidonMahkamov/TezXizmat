
import 'package:tez_xizmat/features/customer_order/domain/entities/get_customer_order_entity.dart';

class GetOrderCustomerModel extends GetCustomerOrderEntity {
  GetOrderCustomerModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.fullName,
  });

  factory GetOrderCustomerModel.fromJson(Map<String, dynamic> json) {
    return GetOrderCustomerModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      fullName: json['full_name'],
    );
  }
}
