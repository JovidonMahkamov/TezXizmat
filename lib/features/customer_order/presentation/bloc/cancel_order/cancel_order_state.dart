import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';

abstract class CancelOrderState {
  const CancelOrderState();
}

class CancelOrderInitial extends CancelOrderState {}

class CancelOrderLoading extends CancelOrderState {}

class CancelOrderSuccess extends CancelOrderState {
  final CancelOrderEntity cancelOrderEntity;

  const CancelOrderSuccess({required this.cancelOrderEntity});
}

class CancelOrderError extends CancelOrderState {
  final String message;

  const CancelOrderError({required this.message});
}
