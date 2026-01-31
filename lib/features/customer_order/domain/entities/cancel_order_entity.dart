import 'order_customer_entity.dart';
import 'order_staff_entity.dart';

class CancelOrderEntity {
  final int id;
  final String status;
  final String address;
  final String problemText;
  final int customerId;
  final int staffId;

  final OrderCustomerEntity customer;
  final OrderStaffEntity staff;

  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedByStaffAt;
  final DateTime? completedByCustomerAt;
  final DateTime? canceledAt;

  final String? canceledBy;
  final String? cancelReason;

  const CancelOrderEntity({
    required this.id,
    required this.status,
    required this.address,
    required this.problemText,
    required this.customerId,
    required this.staffId,
    required this.customer,
    required this.staff,
    required this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedByStaffAt,
    this.completedByCustomerAt,
    this.canceledAt,
    this.canceledBy,
    this.cancelReason,
  });
}