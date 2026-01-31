import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';
import '../repository/worker_home_repository.dart';

class GetStaffOrdersUseCase {
  final WorkerHomeRepository workerHomeRepository;

  GetStaffOrdersUseCase(this.workerHomeRepository);

  Future<List<PutOrdersStateEntity>> call() async {
    return await workerHomeRepository.getStaffOrders();
  }
}