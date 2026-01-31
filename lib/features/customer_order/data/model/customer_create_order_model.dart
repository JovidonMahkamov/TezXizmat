import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';

import 'order_customer_model.dart';
import 'order_staff_model.dart';

class CustomerCreateOrderModel extends CustomerCreateOrderEntity {
  const CustomerCreateOrderModel({
    required super.id,
    required super.status,
    required super.address,
    required super.problemText,
    required super.customerId,
    required super.staffId,
    required super.customer,
    required super.staff,
    required super.createdAt,
    super.acceptedAt,
    super.startedAt,
    super.completedByStaffAt,
    super.completedByCustomerAt,
    super.canceledAt,
    super.canceledBy,
    super.cancelReason,
  });

  factory CustomerCreateOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomerCreateOrderModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      address: json['address'] ?? '',
      problemText: json['problem_text'] ?? '',
      customerId: json['customer_id'] ?? 0,
      staffId: json['staff_id'] ?? 0,
      customer: OrderCustomerModel.fromJson(json['customer']),
      staff: OrderStaffModel.fromJson(json['staff']),
      createdAt: DateTime.parse(json['created_at']),
      acceptedAt: _parseDate(json['accepted_at']),
      startedAt: _parseDate(json['started_at']),
      completedByStaffAt: _parseDate(json['completed_by_staff_at']),
      completedByCustomerAt: _parseDate(json['completed_by_customer_at']),
      canceledAt: _parseDate(json['canceled_at']),
      canceledBy: json['canceled_by'],
      cancelReason: json['cancel_reason'],
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null) return null;
    return DateTime.parse(value);
  }
}
