import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';

abstract class GetCustomerAllOrdersState {
  const GetCustomerAllOrdersState();
}

class GetCustomerAllOrdersInitial extends GetCustomerAllOrdersState {}

class GetCustomerAllOrdersLoading extends GetCustomerAllOrdersState {}

class GetCustomerAllOrdersSuccess extends GetCustomerAllOrdersState {
  final List<GetAllOrdersEntity> getAllOrdersEntity;

  const GetCustomerAllOrdersSuccess({required this.getAllOrdersEntity});
}

class GetCustomerAllOrdersError extends GetCustomerAllOrdersState {
  final String message;

  const GetCustomerAllOrdersError({required this.message});
}
