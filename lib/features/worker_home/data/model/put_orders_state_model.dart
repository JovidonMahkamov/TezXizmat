import 'package:tez_xizmat/features/worker_home/data/model/get_customer_model.dart';
import 'package:tez_xizmat/features/worker_home/data/model/get_staff_orders_model.dart';
import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';

class PutOrdersStateModel extends PutOrdersStateEntity {
  const PutOrdersStateModel({
    required super.id,
    required super.customer,
    required super.staff,
    required super.description,
    required super.address,
    required super.status,
    required super.acceptedAt,
    required super.completedAt,
    required super.canceledAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PutOrdersStateModel.fromJson(Map<String, dynamic> json) {
    return PutOrdersStateModel(
      id: json['id'] ?? 0,
      customer: GetCustomerModel.fromJson(json['customer'] ?? {}),
      staff: GetStaffOrdersModel.fromJson(json['staff'] ?? {}),
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? '',

      acceptedAt: json['accepted_at']?.toString(),
      completedAt: json['completed_at']?.toString(),
      canceledAt: json['canceled_at']?.toString(),

      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  static List<PutOrdersStateModel> listFromJson(dynamic data) {
    if (data is List) {
      return data
          .map((e) => PutOrdersStateModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
