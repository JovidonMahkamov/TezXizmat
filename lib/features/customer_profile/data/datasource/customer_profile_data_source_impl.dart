import 'package:tez_xizmat/core/network/dio_client.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/customer_profile/data/datasource/customer_profile_data_source.dart';
import 'package:tez_xizmat/features/customer_profile/data/model/customer_profile_model.dart';
import 'package:tez_xizmat/features/customer_profile/data/model/customer_update_profile_model.dart';

class CustomerProfileDataSourceImpl extends CustomerProfileDataSource {
  final DioClient dioClient;
  final AuthLocalDataSource authLocalDataSource;

  CustomerProfileDataSourceImpl(this.dioClient, this.authLocalDataSource, );

  @override
  Future<CustomerProfileModel> getProfile() async {
    try {
      final response = await dioClient.get(
        'https://tezxizmatlar.uz/api/auth/customer/profile/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('get profile info successful: ${response.data}');
        return CustomerProfileModel.fromJson(response.data);
      } else {
        LoggerService.warning(
          "get profile info failed: ${response.statusCode}",
        );
        throw Exception('get profile info failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error get profile info: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<CustomerUpdateProfileModel> updateProfile({
    required String name,
    required String surname,
  }) async {
    try {
      final response = await dioClient.patch(
        'https://tezxizmatlar.uz/api/auth/customer/profile/update/',
        data: {"first_name": name, "last_name": surname},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('update profile info successful: ${response.data}');
        return CustomerUpdateProfileModel.fromJson(response.data);
      } else {
        LoggerService.warning(
          "update profile info failed: ${response.statusCode}",
        );
        throw Exception('update profile info failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error update profile info: $e');
      print(e);
      print(s);
      rethrow;
    }
  }
}
