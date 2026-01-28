import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class CustomerCreateOrderUseCase {
  final CustomerOrderRepository customerOrderRepository;

  CustomerCreateOrderUseCase(this.customerOrderRepository);

  Future<CustomerCreateOrderEntity> call({required int staff_id,required String description, required String address}) async {
    return await customerOrderRepository.createOrder(staff_id: staff_id, description: description, address: address);
  }
}
