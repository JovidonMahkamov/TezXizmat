import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';

abstract class WorkerHomeRepository {
  Future<List<PutOrdersStateEntity>> getStaffOrders();

  Future<CancelOrderEntity> acceptOrder({
    required int id,
  });

  Future<CancelOrderEntity> startOrder({
    required int id,
  });

  Future<CancelOrderEntity> completeByStaffOrder({
    required int id,
  });
}