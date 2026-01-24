
import 'package:tez_xizmat/features/auth/domain/entities/customer_reset_password_entity.dart';

abstract class CustomerResetPasswordState {
  const CustomerResetPasswordState();
}

class CustomerResetPasswordInitial extends CustomerResetPasswordState {}

class CustomerResetPasswordLoading extends CustomerResetPasswordState {}

class CustomerResetPasswordSuccess extends CustomerResetPasswordState {
  final CustomerResetPasswordEntity customerResetPasswordEntity;

  const CustomerResetPasswordSuccess({required this.customerResetPasswordEntity});
}

class CustomerResetPasswordError extends CustomerResetPasswordState {
  final String message;

  const CustomerResetPasswordError({required this.message});
}
