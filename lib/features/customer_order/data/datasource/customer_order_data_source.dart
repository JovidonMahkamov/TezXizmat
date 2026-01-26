import 'package:tez_xizmat/features/customer_order/data/model/customer_create_order_model.dart';
import 'package:tez_xizmat/features/customer_order/data/model/get_customer_all_orders_model.dart';

abstract class CustomerOrderDataSource {
  Future<CustomerCreateOrderModel> createOrder({required int staff_id, required String name, required String surname, required String description, required String address});
  Future<List<GetCustomerAllOrdersModel>> getCusAllOrders();
}