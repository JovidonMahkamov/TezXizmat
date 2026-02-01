import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class ConfirmCompletionUseCase {
  final CustomerOrderRepository customerOrderRepository;

  ConfirmCompletionUseCase(this.customerOrderRepository);

  Future<void> call({required int id}) async {
    return await customerOrderRepository.confirmCompletion(id: id);
  }
}
