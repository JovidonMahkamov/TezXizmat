import '../entities/put_orders_state_entity.dart';
import '../repository/worker_home_repository.dart';
import 'staff_order_action.dart';

class PutOrdersStateUseCase {
  final WorkerHomeRepository workerHomeRepository;

  PutOrdersStateUseCase(this.workerHomeRepository);

  Future<PutOrdersStateEntity> call({
    required int orderId,
    required StaffOrderAction action,
  }) {
    return workerHomeRepository.putOrderAction(
      orderId: orderId,
      action: action,
    );
  }
}