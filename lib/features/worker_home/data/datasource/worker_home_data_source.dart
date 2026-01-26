import 'package:tez_xizmat/core/network/dio_client.dart';
import 'package:tez_xizmat/features/worker_home/data/model/get_staff_orders_model.dart';
import '../../../../core/network/api_urls.dart';
import '../model/put_orders_state_model.dart';

abstract class WorkerHomeDataSource {
  final DioClient dioClient;

  WorkerHomeDataSource(this.dioClient);

  Future<List<GetStaffOrdersModel>> getStaffOrders();

  Future<PutOrdersStateModel> accept(int id) async {
    final res = await dioClient.put(ApiUrls.acceptOrder(id));
    return PutOrdersStateModel.fromJson(res.data);
  }

  Future<PutOrdersStateModel> cancel(int id) async {
    final res = await dioClient.put(ApiUrls.cancelOrder(id));
    return PutOrdersStateModel.fromJson(res.data);
  }

  Future<PutOrdersStateModel> complete(int id) async {
    final res = await dioClient.put(ApiUrls.completeOrder(id));
    return PutOrdersStateModel.fromJson(res.data);
  }

}