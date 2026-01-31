import 'package:tez_xizmat/features/customer_order/data/model/cancel_order_model.dart';
import '../model/put_orders_state_model.dart';

abstract class WorkerHomeDataSource {

  Future<List<PutOrdersStateModel>> getStaffOrders();

  Future<CancelOrderModel> acceptOrder({required int id});

  Future<CancelOrderModel> startOrder({required int id});

  Future<CancelOrderModel> completeByStaffOrder({required int id});


}