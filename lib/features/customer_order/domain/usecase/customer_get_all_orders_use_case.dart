import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_customer_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class CustomerGetAllOrdersUseCase {
  final CustomerOrderRepository customerOrderRepository;

  CustomerGetAllOrdersUseCase(this.customerOrderRepository);

  Future<List<GetCustomerAllOrdersEntity>> call() async {
    return await customerOrderRepository.getCusAllOrders();
  }
}
