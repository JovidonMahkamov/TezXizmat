import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class CustomerCreateOrderUseCase {
  final CustomerOrderRepository customerOrderRepository;

  CustomerCreateOrderUseCase(this.customerOrderRepository);

  Future<CustomerCreateOrderEntity> call({required String name, required String surname, required int staff_id,required String description, required String address}) async {
    return await customerOrderRepository.createOrder(staff_id: staff_id, name: name, surname: surname, description: description, address: address);
  }
}
