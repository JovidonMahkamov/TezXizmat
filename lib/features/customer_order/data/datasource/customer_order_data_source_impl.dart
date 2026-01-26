import 'package:tez_xizmat/core/network/api_urls.dart';
import 'package:tez_xizmat/core/network/dio_client.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/customer_order/data/datasource/customer_order_data_source.dart';
import 'package:tez_xizmat/features/customer_order/data/model/customer_create_order_model.dart';
import 'package:tez_xizmat/features/customer_order/data/model/get_customer_all_orders_model.dart';

class CustomerOrderDataSourceImpl implements CustomerOrderDataSource {
  final DioClient dioClient;
  final AuthLocalDataSource local;

  CustomerOrderDataSourceImpl(
     this.dioClient,
     this.local,
  );

  @override
  Future<CustomerCreateOrderModel> createOrder({
    required int staff_id,
    required String name,
    required String surname,
    required String description,
    required String address,
  })async {
    try {
      final response = await dioClient.post(ApiUrls.createOrder,
        data: {
          'staff_id': staff_id,
          'name': name,
          'surname': surname,
          'description': description,
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
  Future<List<GetCustomerAllOrdersModel>> getCusAllOrders() async{
    try {
      final response = await dioClient.get(ApiUrls.getCusAllOrders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('customer create order successful: ${response.data}');
        final data = response.data;
        final List list = data is List ? data : (data['results'] as List);

        return list
            .map((e) => GetCustomerAllOrdersModel.fromJson(e as Map<String, dynamic>))
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
}
