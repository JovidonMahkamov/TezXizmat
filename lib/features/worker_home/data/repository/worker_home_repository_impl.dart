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
  Future<PutOrdersStateEntity> putOrderAction({
    required int orderId,
    required StaffOrderAction action,
  }) async {
    switch (action) {
      case StaffOrderAction.accept:
        return await workerHomeDataSource.accept(orderId);

      case StaffOrderAction.cancel:
        return await workerHomeDataSource.cancel(orderId);

      case StaffOrderAction.complete:
        return await workerHomeDataSource.complete(orderId);

      case StaffOrderAction.pending:
        return await workerHomeDataSource.start(orderId);
    }
  }
}