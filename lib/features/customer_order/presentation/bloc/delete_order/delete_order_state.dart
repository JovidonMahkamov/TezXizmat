import 'package:tez_xizmat/features/customer_order/domain/entities/delete_order_entity.dart';

abstract class DeleteOrderState {
  const DeleteOrderState();
}

class DeleteOrderInitial extends DeleteOrderState {}

class DeleteOrderLoading extends DeleteOrderState {}

class DeleteOrderSuccess extends DeleteOrderState {
  final DeleteOrderEntity deleteOrderEntity;

  const DeleteOrderSuccess({required this.deleteOrderEntity});
}

class DeleteOrderError extends DeleteOrderState {
  final String message;

  const DeleteOrderError({required this.message});
}
