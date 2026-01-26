import 'package:tez_xizmat/features/worker_home/domain/entities/get_staff_orders_entity.dart';
import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';
import '../usecase/staff_order_action.dart';

abstract class WorkerHomeRepository {
  Future<List<GetStaffOrdersEntity>> getStaffOrders();

  Future<PutOrdersStateEntity> putOrderAction({
    required int orderId,
    required StaffOrderAction action,
  });
}