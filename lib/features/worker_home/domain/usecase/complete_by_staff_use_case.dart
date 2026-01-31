import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import '../repository/worker_home_repository.dart';

class CompleteByStaffUseCase {
  final WorkerHomeRepository workerHomeRepository;

  CompleteByStaffUseCase(this.workerHomeRepository);

  Future<CancelOrderEntity> call({
    required int id,
  }) {
    return workerHomeRepository.completeByStaffOrder(
      id: id,
    );
  }
}