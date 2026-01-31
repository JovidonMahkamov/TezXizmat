import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';

abstract class AcceptOrderState {
  const AcceptOrderState();
}

class AcceptOrderInitial extends AcceptOrderState {}

class AcceptOrderLoading extends AcceptOrderState {}

class AcceptOrderSuccess extends AcceptOrderState {
  final CancelOrderEntity cancelOrderEntity;

  const AcceptOrderSuccess({required this.cancelOrderEntity});
}

class AcceptOrderError extends AcceptOrderState {
  final String message;

  const AcceptOrderError({required this.message});
}
