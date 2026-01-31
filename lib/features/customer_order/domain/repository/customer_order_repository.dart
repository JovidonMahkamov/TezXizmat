import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';
import '../entities/get_all_orders_entity.dart';

abstract class CustomerOrderRepository {
  Future<CustomerCreateOrderEntity> createOrder({
    required int staff_id,
    required String description,
    required String address,
  });

  Future<List<GetAllOrdersEntity>> getCusAllOrders();

  Future<CancelOrderEntity> cancelOrder({required String reason, required int id});

  Future<CancelOrderEntity> confirmCompletion({required int id});
}
