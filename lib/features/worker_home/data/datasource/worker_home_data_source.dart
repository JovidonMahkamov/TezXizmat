import 'package:tez_xizmat/core/network/customer_dio_client.dart';
import 'package:tez_xizmat/core/network/staff_api_urls.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/features/worker_home/data/model/get_staff_orders_model.dart';
import '../../../../core/network/customer_api_urls.dart';
import '../model/put_orders_state_model.dart';

abstract class WorkerHomeDataSource {
  final StaffDioClient staffDioClient;
  final CustomerDioClient customerDioClient;

  WorkerHomeDataSource(this.customerDioClient, this.staffDioClient);

  Future<List<GetStaffOrdersModel>> getStaffOrders();

  Future<PutOrdersStateModel> accept(int id) async {
    final res = await customerDioClient.put(StaffApiUrls.acceptOrder(id));
    return PutOrdersStateModel.fromJson(res.data);
  }

  Future<PutOrdersStateModel> cancel(int id) async {
    final res = await customerDioClient.put(StaffApiUrls.cancelOrder(id));
    return PutOrdersStateModel.fromJson(res.data);
  }

  Future<PutOrdersStateModel> complete(int id) async {
    final res = await customerDioClient.put(StaffApiUrls.completeOrder(id));
    return PutOrdersStateModel.fromJson(res.data);
  }

}