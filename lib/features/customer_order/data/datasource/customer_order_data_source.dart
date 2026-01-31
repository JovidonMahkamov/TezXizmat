import 'package:tez_xizmat/features/customer_order/data/model/customer_create_order_model.dart';
import 'package:tez_xizmat/features/customer_order/data/model/get_all_orders_model.dart';
import '../model/cancel_order_model.dart';

abstract class CustomerOrderDataSource {
  Future<CustomerCreateOrderModel> createOrder({required int staff_id, required String description, required String address});
  Future<List<GetAllOrdersModel>> getCusAllOrders();
  Future<CancelOrderModel> cancelOrder({required String reason, required int id});
  Future<CancelOrderModel> confirmCompletion({required int id});
}