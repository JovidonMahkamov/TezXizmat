import 'package:tez_xizmat/features/customer_home/domain/entities/customer_get_all_staff_entity.dart';

abstract class CustomerGetAllStaffState {
  const CustomerGetAllStaffState();
}

class CustomerGetAllStaffInitial extends CustomerGetAllStaffState {}

class CustomerGetAllStaffLoading extends CustomerGetAllStaffState {}

class CustomerGetAllStaffSuccess extends CustomerGetAllStaffState {
  final List <CustomerGetAllStaffEntity> customerGetAllStaffEntity;

  const CustomerGetAllStaffSuccess({required this.customerGetAllStaffEntity});
}

class CustomerGetAllStaffError extends CustomerGetAllStaffState {
  final String message;

  const CustomerGetAllStaffError({required this.message});
}
