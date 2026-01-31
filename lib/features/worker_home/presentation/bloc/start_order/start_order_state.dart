import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';

abstract class StartOrderState {
  const StartOrderState();
}

class StartOrderInitial extends StartOrderState {}

class StartOrderLoading extends StartOrderState {}

class StartOrderSuccess extends StartOrderState {
  final CancelOrderEntity cancelOrderEntity;

  const StartOrderSuccess({required this.cancelOrderEntity});
}

class StartOrderError extends StartOrderState {
  final String message;

  const StartOrderError({required this.message});
}
