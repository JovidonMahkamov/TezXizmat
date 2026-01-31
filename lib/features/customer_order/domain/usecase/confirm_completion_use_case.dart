import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class ConfirmCompletionUseCase {
  final CustomerOrderRepository customerOrderRepository;

  ConfirmCompletionUseCase(this.customerOrderRepository);

  Future<CancelOrderEntity> call({required int id}) async {
    return await customerOrderRepository.confirmCompletion(id: id);
  }
}
