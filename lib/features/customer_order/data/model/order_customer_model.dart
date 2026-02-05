import 'package:tez_xizmat/features/customer_order/domain/entities/order_customer_entity.dart';

class OrderCustomerModel extends OrderCustomerEntity {
  const OrderCustomerModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.image,
  });

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) {
    return OrderCustomerModel(
      id: (json['id'] ?? 0) as int,
      firstName: (json['first_name'] ?? '') as String,
      lastName: (json['last_name'] ?? '') as String,
      image: (json['image'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'image': image,
    };
  }
}
