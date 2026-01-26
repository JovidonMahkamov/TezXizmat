import 'package:equatable/equatable.dart';

class PutOrdersStateEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String address;
  final String status;

  final String? acceptedAt;
  final String? completedAt;
  final String? canceledAt;

  final String createdAt;
  final String updatedAt;

  final int customer;
  final int staff;

  const PutOrdersStateEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.status,
    required this.acceptedAt,
    required this.completedAt,
    required this.canceledAt,
    required this.createdAt,
    required this.updatedAt,
    required this.customer,
    required this.staff,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    address,
    status,
    acceptedAt,
    completedAt,
    canceledAt,
    createdAt,
    updatedAt,
    customer,
    staff,
  ];
}
