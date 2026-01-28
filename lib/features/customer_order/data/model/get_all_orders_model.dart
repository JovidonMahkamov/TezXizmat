import 'package:tez_xizmat/features/customer_order/data/model/get_order_customer_model.dart';
import '../../domain/entities/get_all_orders_entity.dart';
import 'get_staff_order_model.dart';

class GetAllOrdersModel extends GetAllOrdersEntity {
  GetAllOrdersModel({
    required super.id,
    required super.customer,
    required super.staff,
    required super.description,
    required super.address,
    required super.status,
    super.acceptedAt,
    super.completedAt,
    super.canceledAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GetAllOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetAllOrdersModel(
      id: json['id'],
      customer: GetOrderCustomerModel.fromJson(json['customer'] ?? {}),
      staff: GetOrderStaffModel.fromJson(json['staff']),
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      status: json['status'],
      acceptedAt: json['accepted_at'],
      completedAt: json['completed_at'],
      canceledAt: json['canceled_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
