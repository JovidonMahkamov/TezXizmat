import 'package:equatable/equatable.dart';
import 'package:tez_xizmat/features/worker_home/domain/entities/get_staff_orders_entity.dart';
import 'customer_entity.dart';

class PutOrdersStateEntity extends Equatable {
  final int id;
  final CustomerEntity customer;
  final GetStaffOrdersEntity staff;
  final String description;
  final String address;
  final String status;

  final String? acceptedAt;
  final String? completedAt;
  final String? canceledAt;

  final String createdAt;
  final String updatedAt;

  const PutOrdersStateEntity({
    required this.id,
    required this.customer,
    required this.staff,
    required this.description,
    required this.address,
    required this.status,
    required this.acceptedAt,
    required this.completedAt,
    required this.canceledAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    customer,
    staff,
    description,
    address,
    status,
    acceptedAt,
    completedAt,
    canceledAt,
    createdAt,
    updatedAt,
  ];
}
