import '../../domain/entities/get_all_orders_entity.dart';

class GetAllOrdersModel extends GetAllOrdersEntity {
  GetAllOrdersModel({
    required super.id,
    required super.customerId,
    required super.staffId,
    required super.problemText,
    required super.address,
    required super.status,
    required super.createdAt,
    super.acceptedAt,
    super.canceledAt,
    super.canceledBy,
    super.cancelReason,
    super.completedByCustomerAt,
    super.completedByStaffAt,
    super.startedAt,
  });

  factory GetAllOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetAllOrdersModel(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      staffId: json['staff_id'] ?? 0,
      problemText: json['problem_text'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? "",

      acceptedAt: json['accepted_at'],
      startedAt: json['started_at'],
      completedByStaffAt: json['completed_by_staff_at'],
      completedByCustomerAt: json['completed_by_customer_at'],
      canceledAt: json['canceled_at'],

      canceledBy: json['canceled_by'],
      cancelReason: json['cancel_reason'],

      createdAt: json['created_at'] ?? "",
    );
  }
}
