import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';

abstract class CustomerCreateOrderState {
  const CustomerCreateOrderState();
}

class CustomerCreateOrderInitial extends CustomerCreateOrderState {}

class CustomerCreateOrderLoading extends CustomerCreateOrderState {}

class CustomerCreateOrderSuccess extends CustomerCreateOrderState {
  final CustomerCreateOrderEntity customerCreateOrderEntity;

  const CustomerCreateOrderSuccess({required this.customerCreateOrderEntity});
}

class CustomerCreateOrderError extends CustomerCreateOrderState {
  final String message;

  const CustomerCreateOrderError({required this.message});
}
