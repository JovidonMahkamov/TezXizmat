import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class CustomerGetAllOrdersUseCase {
  final CustomerOrderRepository customerOrderRepository;

  CustomerGetAllOrdersUseCase(this.customerOrderRepository);

  Future<List<GetAllOrdersEntity>> call() async {
    return await customerOrderRepository.getCusAllOrders();
  }
}
