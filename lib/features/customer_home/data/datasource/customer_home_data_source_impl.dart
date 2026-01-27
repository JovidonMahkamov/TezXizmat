import 'package:tez_xizmat/core/network/customer_api_urls.dart';
import 'package:tez_xizmat/core/network/customer_dio_client.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/customer_home/data/datasource/customer_home_data_source.dart';
import 'package:tez_xizmat/features/customer_home/data/model/customer_get_all_staff_model.dart';
import 'package:tez_xizmat/features/customer_home/data/model/get_worker_info_model.dart';
import 'package:tez_xizmat/features/customer_home/data/model/get_worker_reviews_model.dart';

class CustomerHomeDataSourceImpl implements CustomerHomeDataSource {
  final StaffDioClient staffDioClient;
  final CustomerDioClient customerDioClient;

  CustomerHomeDataSourceImpl(this.staffDioClient, this.customerDioClient);

  @override
  Future<List<CustomerGetAllStaffModel>> getAllStaff() async {
    try {
      final response = await customerDioClient.get(CustomerApiUrls.getAllStaff);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('customer get all staff successful: ${response.data}');

        final data = response.data;
        final List list = data is List ? data : (data['results'] as List);

        return list
            .map((e) => CustomerGetAllStaffModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        LoggerService.warning("customer get all staff failed: ${response.statusCode}");
        throw Exception('customer get all staff failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during customer get all staff: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<GetWorkerInfoModel> getWorkerInfo({required int id}) async{
    try {
      final response = await customerDioClient.get("${CustomerApiUrls.getWorkerInfo}/$id/");
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('get worker info successful: ${response.data}');
        return GetWorkerInfoModel.fromJson(response.data);
      } else {
        LoggerService.warning(
          "get worker info  failed: ${response.statusCode}",
        );
        throw Exception('get worker info  failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during get worker info : $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<List<GetWorkerReviewsModel>> getWorkerReviews({required int id}) async {
    try {
      final response = await customerDioClient.get("${CustomerApiUrls.getWorkerReviews}$id/");
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('get worker info successful: ${response.data}');
        final data = response.data;
        final List list = data is List ? data : (data['results'] as List);

        return list
            .map((e) => GetWorkerReviewsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        LoggerService.warning(
          "get worker info  failed: ${response.statusCode}",
        );
        throw Exception('get worker info  failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during get worker info : $e');
      print(e);
      print(s);
      rethrow;
    }
  }
}
