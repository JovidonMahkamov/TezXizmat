import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';

abstract class CustomerOrderRepository {
  Future<CustomerCreateOrderEntity> createOrder(
      {required int staff_id, required String name, required String surname, required String description, required String address});
}