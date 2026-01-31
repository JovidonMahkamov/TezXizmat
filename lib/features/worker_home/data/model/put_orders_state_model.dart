import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';

class PutOrdersStateModel extends PutOrdersStateEntity {
  const PutOrdersStateModel({
    required super.id,
    required super.status,
    required super.address,
    required super.problemText,
    required super.customerId,
    required super.staffId,
    required super.customer,
    required super.createdAt,
    super.acceptedAt,
    super.startedAt,
    super.completedByStaffAt,
    super.completedByCustomerAt,
    super.canceledAt,
    super.canceledBy,
    super.cancelReason,
  });

  factory PutOrdersStateModel.fromJson(Map<String, dynamic> json) {
    final c = (json['customer'] as Map<String, dynamic>?) ?? {};

    return PutOrdersStateModel(
      id: json['id'] ?? 0,
      status: json['status']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      problemText: json['problem_text']?.toString() ?? '',
      customerId: json['customer_id'] ?? 0,
      staffId: json['staff_id'] ?? 0,

      customer: OrderCustomerShortEntity(
        id: c['id'] ?? 0,
        firstName: c['first_name']?.toString() ?? '',
        lastName: c['last_name']?.toString() ?? '',
        image: c['image']?.toString() ?? '',
      ),

      createdAt: json['created_at']?.toString() ?? '',

      acceptedAt: json['accepted_at']?.toString(),
      startedAt: json['started_at']?.toString(),
      completedByStaffAt: json['completed_by_staff_at']?.toString(),
      completedByCustomerAt: json['completed_by_customer_at']?.toString(),
      canceledAt: json['canceled_at']?.toString(),

      canceledBy: json['canceled_by']?.toString(),
      cancelReason: json['cancel_reason']?.toString(),
    );
  }
}