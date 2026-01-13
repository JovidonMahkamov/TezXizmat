
import 'package:tez_xizmat/features/auth/domain/entities/customer_verify_email_entity.dart';

abstract class CustomerVerifyEmailState {
  const CustomerVerifyEmailState();
}

class CustomerVerifyEmailInitial extends CustomerVerifyEmailState {}

class CustomerVerifyEmailLoading extends CustomerVerifyEmailState {}

class CustomerVerifyEmailSuccess extends CustomerVerifyEmailState {
  final CustomerVerifyEmailEntity customerVerifyEmailEntity;

  const CustomerVerifyEmailSuccess({required this.customerVerifyEmailEntity});
}

class CustomerVerifyEmailError extends CustomerVerifyEmailState {
  final String message;

  const CustomerVerifyEmailError({required this.message});
}
