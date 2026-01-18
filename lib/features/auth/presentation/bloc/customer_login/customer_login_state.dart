
import 'package:tez_xizmat/features/auth/domain/entities/customer_login_entity.dart';

abstract class CustomerLoginState {
  const CustomerLoginState();
}

class CustomerLoginInitial extends CustomerLoginState {}

class CustomerLoginLoading extends CustomerLoginState {}

class CustomerLoginSuccess extends CustomerLoginState {
  final CustomerLoginEntity customerLoginEntity;

  const CustomerLoginSuccess({required this.customerLoginEntity});
}

class CustomerLoginError extends CustomerLoginState {
  final String message;

  const CustomerLoginError({required this.message});
}
