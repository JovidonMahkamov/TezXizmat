import 'package:tez_xizmat/core/network/staff_api_urls.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/features/customer_order/data/model/cancel_order_model.dart';
import 'package:tez_xizmat/features/worker_home/data/datasource/worker_home_data_source.dart';
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
      final response = await staffDioClient.get(StaffApiUrls.getStaffOrders);

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
  Future<CancelOrderModel> acceptOrder({required int id}) async{
    try {
      final response = await staffDioClient.put("${StaffApiUrls.acceptOrderByW}${id}/accept/");

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('accept order successful: ${response.data}');
        return CancelOrderModel.fromJson(response.data);

      } else {
        LoggerService.warning(
            "accept order failed: ${response.statusCode}");
        throw Exception('accept order failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during accept order : $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<CancelOrderModel> startOrder({required int id}) async {
    try {
      final response = await staffDioClient.put("${StaffApiUrls.startOrderByW}${id}/start/");

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('start order successful: ${response.data}');
        return CancelOrderModel.fromJson(response.data);

      } else {
        LoggerService.warning(
            "start order failed: ${response.statusCode}");
        throw Exception('start order failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during start order : $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<CancelOrderModel> completeByStaffOrder({required int id}) async{
    try {
      final response = await staffDioClient.put("${StaffApiUrls.completeOrderByW}${id}/complete-by-staff/");

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('complete order successful: ${response.data}');
        return CancelOrderModel.fromJson(response.data);

      } else {
        LoggerService.warning(
            "complete order failed: ${response.statusCode}");
        throw Exception('complete order failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during complete order : $e');
      print(e);
      print(s);
      rethrow;
    }
  }
}