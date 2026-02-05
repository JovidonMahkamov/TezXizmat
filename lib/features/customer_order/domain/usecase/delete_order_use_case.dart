import 'package:tez_xizmat/features/customer_order/domain/entities/delete_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class OrderDeleteUseCase {
  final CustomerOrderRepository repo;
  OrderDeleteUseCase(this.repo);

  Future<DeleteOrderEntity> call({required int id}) {
    return repo.deleteOrder(id: id);
  }
}
