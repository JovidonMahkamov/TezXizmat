import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class CancelOrderUseCase {
  final CustomerOrderRepository customerOrderRepository;

  CancelOrderUseCase(this.customerOrderRepository);

  Future<CancelOrderEntity> call({required String reason, required int id}) async {
    return await customerOrderRepository.cancelOrder(reason: reason, id: id);
  }
}
