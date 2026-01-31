import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import 'package:tez_xizmat/features/worker_home/data/datasource/worker_home_data_source.dart';
import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';
import 'package:tez_xizmat/features/worker_home/domain/repository/worker_home_repository.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/staff_order_action.dart';

class WorkerHomeRepositoryImpl implements WorkerHomeRepository {
  final WorkerHomeDataSource workerHomeDataSource;

  WorkerHomeRepositoryImpl({required this.workerHomeDataSource});

  @override
  Future<List<PutOrdersStateEntity>> getStaffOrders() {
    return workerHomeDataSource.getStaffOrders();
  }


  @override
  Future<CancelOrderEntity> acceptOrder({required int id}){
    return workerHomeDataSource.acceptOrder(id: id);
  }

  @override
  Future<CancelOrderEntity> startOrder({required int id}) {
    return workerHomeDataSource.startOrder(id: id);
  }

  @override
  Future<CancelOrderEntity> completeByStaffOrder({required int id}) {
    return workerHomeDataSource.completeByStaffOrder(id: id);
  }

}