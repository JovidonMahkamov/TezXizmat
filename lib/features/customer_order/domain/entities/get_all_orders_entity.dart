import 'package:tez_xizmat/features/customer_order/domain/entities/get_customer_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_staff_order_entity.dart';

class GetAllOrdersEntity {
  final int id;
  final GetCustomerOrderEntity customer;
  final GetStaffOrderEntity staff;
  final String description;
  final String address;
  final String status;
  final String? acceptedAt;
  final String? completedAt;
  final String? canceledAt;
  final String createdAt;
  final String updatedAt;

  GetAllOrdersEntity({
    required this.id,
    required this.customer,
    required this.staff,
    required this.description,
    required this.address,
    required this.status,
    this.acceptedAt,
    this.completedAt,
    this.canceledAt,
    required this.createdAt,
    required this.updatedAt,
  });
}