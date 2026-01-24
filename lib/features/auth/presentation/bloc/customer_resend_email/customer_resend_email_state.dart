import 'package:tez_xizmat/features/auth/domain/entities/customer_resend_email_entity.dart';

abstract class  CustomerResendEmailState {
  const CustomerResendEmailState();
}

class CustomerResendEmailInitial extends CustomerResendEmailState {}

class CustomerResendEmailLoading extends CustomerResendEmailState {}

class CustomerResendEmailSuccess extends CustomerResendEmailState {
  final CustomerResendEmailEntity customerResendEmailEntity;

  const CustomerResendEmailSuccess({required this.customerResendEmailEntity});
}

class CustomerResendEmailError extends CustomerResendEmailState {
  final String message;

  const CustomerResendEmailError({required this.message});
}
