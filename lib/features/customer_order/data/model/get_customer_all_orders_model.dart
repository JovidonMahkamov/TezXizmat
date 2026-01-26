import '../../domain/entities/get_customer_all_orders_entity.dart';

class GetCustomerAllOrdersModel extends GetCustomerAllOrdersEntity {
  const GetCustomerAllOrdersModel({
    required super.id,
    required super.customerName,
    required super.staffName,
    required super.title,
    required super.description,
    required super.address,
    required super.status,
    required super.acceptedAt,
    required super.completedAt,
    required super.canceledAt,
    required super.createdAt,
    required super.updatedAt,
    required super.customer,
    required super.staff,
  });

  factory GetCustomerAllOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetCustomerAllOrdersModel(
      id: json['id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      staffName: json['staff_name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'PENDING',

      acceptedAt: json['accepted_at'],
      completedAt: json['completed_at'],
      canceledAt: json['canceled_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',

      customer: json['customer'] ?? 0,
      staff: json['staff'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customer_name": customerName,
      "staff_name": staffName,
      "title": title,
      "description": description,
      "address": address,
      "status": status,
      "accepted_at": acceptedAt,
      "completed_at": completedAt,
      "canceled_at": canceledAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "customer": customer,
      "staff": staff,
    };
  }
}
