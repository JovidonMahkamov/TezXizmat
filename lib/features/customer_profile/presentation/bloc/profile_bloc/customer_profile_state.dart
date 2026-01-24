import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_profile_entity.dart';

abstract class CustomerProfileState {
  const CustomerProfileState();
}

class CustomerProfileInitial extends CustomerProfileState {}

class CustomerProfileLoading extends CustomerProfileState {}

class CustomerProfileSuccess extends CustomerProfileState {
  final CustomerProfileEntity customerProfileEntity;

  const CustomerProfileSuccess({required this.customerProfileEntity});
}

class CustomerProfileError extends CustomerProfileState {
  final String message;

  const CustomerProfileError({required this.message});
}
