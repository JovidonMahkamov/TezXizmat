import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import '../repository/worker_home_repository.dart';

class AcceptOrderUseCase {
  final WorkerHomeRepository workerHomeRepository;

  AcceptOrderUseCase(this.workerHomeRepository);

  Future<CancelOrderEntity> call({
    required int id,
  }) {
    return workerHomeRepository.acceptOrder(
      id: id,
    );
  }
}