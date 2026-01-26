import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';

abstract class PutOrdersState {
  const PutOrdersState();
}

class PutOrdersStateInitial extends PutOrdersState {}

class PutOrdersStateLoading extends PutOrdersState {}

class PutOrdersStateSuccess extends PutOrdersState {
  final PutOrdersStateEntity putOrdersStateEntity;

  const PutOrdersStateSuccess({required this.putOrdersStateEntity});
}

class PutOrdersStateError extends PutOrdersState {
  final String message;

  const PutOrdersStateError({required this.message});
}
