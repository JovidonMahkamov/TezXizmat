import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import '../repository/worker_home_repository.dart';

class StartOrderUseCase {
  final WorkerHomeRepository workerHomeRepository;

  StartOrderUseCase(this.workerHomeRepository);

  Future<CancelOrderEntity> call({
    required int id,
  }) {
    return workerHomeRepository.startOrder(
      id: id,
    );
  }
}