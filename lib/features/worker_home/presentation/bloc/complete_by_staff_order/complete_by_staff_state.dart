import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';

abstract class CompleteByStaffState {
  const CompleteByStaffState();
}

class CompleteByStaffInitial extends CompleteByStaffState {}

class CompleteByStaffLoading extends CompleteByStaffState {}

class CompleteByStaffSuccess extends CompleteByStaffState {
  final CancelOrderEntity cancelOrderEntity;

  const CompleteByStaffSuccess({required this.cancelOrderEntity});
}

class CompleteByStaffError extends CompleteByStaffState {
  final String message;

  const CompleteByStaffError({required this.message});
}
