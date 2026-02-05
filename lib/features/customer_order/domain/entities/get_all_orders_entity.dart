import 'package:equatable/equatable.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/order_customer_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/order_staff_entity.dart';

class GetAllOrdersEntity extends Equatable {
  final int id;
  final String status;
  final String address;
  final String problemText;
  final OrderCustomerEntity customer;
  final OrderStaffEntity staff;
  final DateTime createdAt;
  final String? acceptedAt;
  final String? startedAt;
  final String? completedByStaffAt;
  final String? completedByCustomerAt;
  final String? canceledAt;

  final String? canceledBy;
  final String? cancelReason;

  const GetAllOrdersEntity({
    this.acceptedAt,
    this.cancelReason,
    this.startedAt,
    this.completedByStaffAt,
    this.completedByCustomerAt,
    this.canceledAt,
    this.canceledBy,
    required this.id,
    required this.status,
    required this.address,
    required this.problemText,
    required this.customer,
    required this.staff,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    status,
    address,
    problemText,
    customer,
    staff,
    createdAt,
  ];
}
