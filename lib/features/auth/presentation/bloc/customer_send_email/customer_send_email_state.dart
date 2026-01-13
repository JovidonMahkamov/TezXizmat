
import 'package:tez_xizmat/features/auth/domain/entities/customer_send_email_entity.dart';

abstract class CustomerSendEmailState {
  const CustomerSendEmailState();
}

class CustomerSendEmailInitial extends CustomerSendEmailState {}

class CustomerSendEmailLoading extends CustomerSendEmailState {}

class CustomerSendEmailSuccess extends CustomerSendEmailState {
  final CustomerSendEmailEntity customerSendEmailEntity;

  const CustomerSendEmailSuccess({required this.customerSendEmailEntity});
}

class CustomerSendEmailError extends CustomerSendEmailState {
  final String message;

  const CustomerSendEmailError({required this.message});
}
