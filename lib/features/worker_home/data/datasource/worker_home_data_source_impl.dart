import 'package:tez_xizmat/core/network/staff_api_urls.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/features/worker_home/data/datasource/worker_home_data_source.dart';
import 'package:tez_xizmat/features/worker_home/data/model/get_staff_orders_model.dart';
import 'package:tez_xizmat/features/worker_home/data/model/put_orders_state_model.dart';
import '../../../../core/network/customer_dio_client.dart';
import '../../../../core/untils/logger.dart';

class WorkerHomeDataSourceImpl implements WorkerHomeDataSource {
  final StaffDioClient staffDioClient;
  final CustomerDioClient customerDioClient;

  WorkerHomeDataSourceImpl(this.staffDioClient, this.customerDioClient);

  @override
  Future<List<PutOrdersStateModel>> getStaffOrders() async {
    try {
      final response = await customerDioClient.get(StaffApiUrls.getStaffOrders);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('get staff orders successful: ${response.data}');

        final data = response.data;
        final List list = data is List ? data : (data['results'] as List);

        return list
            .map((e) => PutOrdersStateModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        LoggerService.warning(
            "get staff orders failed: ${response.statusCode}");
        throw Exception('get staff orders failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during get staff orders: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<PutOrdersStateModel> accept(int id) async{
    try {
      final response = await customerDioClient.put(StaffApiUrls.acceptOrder(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('put orders accept successful: ${response.data}');
        return PutOrdersStateModel.fromJson(response.data);

      } else {
        LoggerService.warning(
            "put orders accept failed: ${response.statusCode}");
        throw Exception('put orders accept failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during put orders accept : $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<PutOrdersStateModel> cancel(int id) async{
    try {
      final response = await customerDioClient.put(StaffApiUrls.cancelOrder(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('put orders cancel successful: ${response.data}');
        return PutOrdersStateModel.fromJson(response.data);

      } else {
        LoggerService.warning(
            "put orders cancel failed: ${response.statusCode}");
        throw Exception('put orders cancel failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during put orders cancel : $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<PutOrdersStateModel> complete(int id) async {
    try {
      final response = await customerDioClient.put(StaffApiUrls.completeOrder(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('put orders complete successful: ${response.data}');
        return PutOrdersStateModel.fromJson(response.data);

      } else {
        LoggerService.warning(
            "put orders complete failed: ${response.statusCode}");
        throw Exception('put orders complete failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during put orders complete : $e');
      print(e);
      print(s);
      rethrow;
    }
  }
}