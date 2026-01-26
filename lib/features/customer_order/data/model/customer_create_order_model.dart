import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';

class CustomerCreateOrderModel extends CustomerCreateOrderEntity {
  const CustomerCreateOrderModel({
    required super.id, required super.name, required super.surname, required super.description, required super.address,
  });
  factory CustomerCreateOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomerCreateOrderModel(
      id: json['id'], name: json['name'], surname: json['surname'], description: json['description'] ?? "", address: json['address'] ?? "",
    );
  }
}
