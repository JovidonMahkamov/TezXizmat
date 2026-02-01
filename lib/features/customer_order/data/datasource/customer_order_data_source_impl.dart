import 'package:tez_xizmat/core/network/customer_api_urls.dart';
import 'package:tez_xizmat/core/network/customer_dio_client.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/customer_order/data/datasource/customer_order_data_source.dart';
import 'package:tez_xizmat/features/customer_order/data/model/cancel_order_model.dart';
import 'package:tez_xizmat/features/customer_order/data/model/customer_create_order_model.dart';
import 'package:tez_xizmat/features/customer_order/data/model/get_all_orders_model.dart';

class CustomerOrderDataSourceImpl implements CustomerOrderDataSource {
  final CustomerDioClient customerDioClient;
  final AuthLocalDataSource local;

  CustomerOrderDataSourceImpl(
     this.customerDioClient,
     this.local,
  );

  @override
  Future<CustomerCreateOrderModel> createOrder({
    required int staff_id,
    required String description,
    required String address,
  })async {
    try {
      final response = await customerDioClient.post(CustomerApiUrls.createOrder,
        data: {
          'staff_id': staff_id,
          'problem_text': description,
          'address': address,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('customer create order successful: ${response.data}');
        return CustomerCreateOrderModel.fromJson(response.data);
      } else {
        LoggerService.warning(
          "customer create order failed: ${response.statusCode}",
        );
        throw Exception('customer create order failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during customer create order: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<List<GetAllOrdersModel>> getCusAllOrders() async{
    try {
      final response = await customerDioClient.get(CustomerApiUrls.getCusAllOrders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('customer create order successful: ${response.data}');
        final data = response.data;
        final List list = data is List ? data : (data['results'] as List);

        return list
            .map((e) => GetAllOrdersModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        LoggerService.warning(
          "get customer all orders failed: ${response.statusCode}",
        );
        throw Exception('get customer all orders failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during get customer all orders: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<CancelOrderModel> cancelOrder({required String reason, required int id}) async{
    try {
      final response = await customerDioClient.put("${CustomerApiUrls.cancelOrder}$id/cancel/",
        data: {
          'reason': reason,
          'id': id,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('cancel order successful: ${response.data}');
        return CancelOrderModel.fromJson(response.data);
      } else {
        LoggerService.warning(
          "cancel order failed: ${response.statusCode}",
        );
        throw Exception('cancel order failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during cancel order: $e');
      print(e);
      print(s);
      rethrow;
    }
  }
  @override
  Future<void> confirmCompletion({required int id}) async {
    try {
      final response = await customerDioClient.put(
        "${CustomerApiUrls.confirmCompletion}$id/confirm-completion/",
        data: null, // ko‘pincha body kerak emas
      );

      // 200/201/204 ham success bo‘lsin
      final ok = response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204;

      if (ok) {
        LoggerService.info('confirm completion success: ${response.statusCode}');
        return;
      }

      LoggerService.warning("confirm completion failed: ${response.statusCode} data=${response.data}");
      throw Exception('confirm completion failed: ${response.statusCode}');
    } catch (e, s) {
      LoggerService.error('Error confirm completion: $e');
      print(s);
      rethrow;
    }
  }

}
