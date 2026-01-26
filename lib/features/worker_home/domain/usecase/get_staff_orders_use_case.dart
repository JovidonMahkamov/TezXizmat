import 'package:tez_xizmat/features/worker_home/domain/entities/get_staff_orders_entity.dart';
import '../repository/worker_home_repository.dart';

class GetStaffOrdersUseCase {
  final WorkerHomeRepository workerHomeRepository;

  GetStaffOrdersUseCase(this.workerHomeRepository);

  Future<List<GetStaffOrdersEntity>> call() async {
    return await workerHomeRepository.getStaffOrders();
  }
}