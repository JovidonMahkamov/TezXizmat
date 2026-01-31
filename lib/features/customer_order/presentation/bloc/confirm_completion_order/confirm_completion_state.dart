import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';

abstract class ConfirmCompletionState {
  const ConfirmCompletionState();
}

class ConfirmCompletionInitial extends ConfirmCompletionState {}

class ConfirmCompletionLoading extends ConfirmCompletionState {}

class ConfirmCompletionSuccess extends ConfirmCompletionState {
  final CancelOrderEntity cancelOrderEntity;

  const ConfirmCompletionSuccess({required this.cancelOrderEntity});
}

class ConfirmCompletionError extends ConfirmCompletionState {
  final String message;

  const ConfirmCompletionError({required this.message});
}
