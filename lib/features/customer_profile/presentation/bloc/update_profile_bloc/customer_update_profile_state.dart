import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_update_profile_entity.dart';

abstract class  CustomerUpdateProfileState{
  const CustomerUpdateProfileState();
}

class CustomerUpdateProfileInitial extends CustomerUpdateProfileState {}

class CustomerUpdateProfileLoading extends CustomerUpdateProfileState {}

class CustomerUpdateProfileSuccess extends CustomerUpdateProfileState {
  final CustomerUpdateProfileEntity customerUpdateProfileEntity;


  const CustomerUpdateProfileSuccess({required this.customerUpdateProfileEntity,});
}

class CustomerUpdateProfileError extends CustomerUpdateProfileState {
  final String message;

  const CustomerUpdateProfileError({required this.message});
}
