
import 'package:tez_xizmat/features/auth/domain/entities/customer_register_entity.dart';

abstract class CustomerRegisterState {
  const CustomerRegisterState();
}

class CustomerRegisterInitial extends CustomerRegisterState {}

class CustomerRegisterLoading extends CustomerRegisterState {}

class CustomerRegisterSuccess extends CustomerRegisterState {
  final CustomerRegisterEntity customerRegisterEntity;

  const CustomerRegisterSuccess({required this.customerRegisterEntity});
}

class CustomerRegisterError extends CustomerRegisterState {
  final String message;

  const CustomerRegisterError({required this.message});
}
