import 'package:tez_xizmat/features/worker_home/domain/entities/get_staff_orders_entity.dart';

class GetStaffOrdersModel extends GetStaffOrdersEntity {
  const GetStaffOrdersModel({
    required super.accepted_at,
    required super.address,
    required super.canceled_at,
    required super.completed_at,
    required super.created_at,
    required super.id,
    required super.customer,
    required super.description,
    required super.staff,
    required super.status,
    required super.title,
    required super.updated_at,
  });

  factory GetStaffOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetStaffOrdersModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      address: json['address'] ?? "",
      status: json['status'] ?? "",
      accepted_at: json['accepted_at'] ?? "",
      completed_at: json['completed_at'] ?? "",
      canceled_at: json['canceled_at'] ?? "",
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
      customer: json['customer'] ?? 0,
      staff: json['staff'] ?? 0,
    );
  }
}
