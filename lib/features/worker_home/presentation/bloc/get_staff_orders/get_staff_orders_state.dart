import 'package:tez_xizmat/features/worker_home/domain/entities/get_staff_orders_entity.dart';

abstract class GetStaffOrdersState {
  const GetStaffOrdersState();
}

class GetStaffOrdersInitial extends GetStaffOrdersState {}

class GetStaffOrdersLoading extends GetStaffOrdersState {}

class GetStaffOrdersSuccess extends GetStaffOrdersState {
  final List <GetStaffOrdersEntity> getStaffOrdersEntity;

  const GetStaffOrdersSuccess({required this.getStaffOrdersEntity});
}

class GetStaffOrdersError extends GetStaffOrdersState {
  final String message;

  const GetStaffOrdersError({required this.message});
}
