
import '../../../domain/entities/put_orders_state_entity.dart';

abstract class GetStaffOrdersState {
  const GetStaffOrdersState();
}

class GetStaffOrdersInitial extends GetStaffOrdersState {}

class GetStaffOrdersLoading extends GetStaffOrdersState {}

class GetStaffOrdersSuccess extends GetStaffOrdersState {
  final List <PutOrdersStateEntity> putOrdersStateEntity;

  const GetStaffOrdersSuccess({required this.putOrdersStateEntity});
}

class GetStaffOrdersError extends GetStaffOrdersState {
  final String message;

  const GetStaffOrdersError({required this.message});
}
