import '../../domain/entities/order_customer_entity.dart';

class OrderCustomerModel extends OrderCustomerEntity {
  const OrderCustomerModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.image,
  });

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) {
    return OrderCustomerModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}