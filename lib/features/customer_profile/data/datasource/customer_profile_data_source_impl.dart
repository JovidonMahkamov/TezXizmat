import 'package:dio/dio.dart';
import 'package:tez_xizmat/core/network/customer_api_urls.dart';
import 'package:tez_xizmat/core/network/customer_dio_client.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/customer_profile/data/datasource/customer_profile_data_source.dart';
import 'package:tez_xizmat/features/customer_profile/data/model/customer_profile_image_model.dart';
import 'package:tez_xizmat/features/customer_profile/data/model/customer_profile_model.dart';
import 'package:tez_xizmat/features/customer_profile/data/model/customer_update_profile_model.dart';
import 'package:path/path.dart' as p;
class CustomerProfileDataSourceImpl extends CustomerProfileDataSource {
  final StaffDioClient staffDioClient;
  final CustomerDioClient customerDioClient;
  final AuthLocalDataSource authLocalDataSource;

  CustomerProfileDataSourceImpl(this.customerDioClient, this.staffDioClient, this.authLocalDataSource, );

  @override
  Future<CustomerProfileModel> getProfile() async {
    try {
      final response = await customerDioClient.get(
        CustomerApiUrls.getProfile,
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
      final response = await customerDioClient.patch(
        CustomerApiUrls.updateProfile,
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

  @override
  Future<CustomerProfileImageModel> updateImage({required String filePath})async {
    try {
      final fileName = p.basename(filePath);

      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      final response = await customerDioClient.put(
        CustomerApiUrls.updateImage,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('update worker profile image successful: ${response.data}');
        return CustomerProfileImageModel.fromJson(response.data);
      } else {
        LoggerService.warning("update worker profile image failed: ${response.statusCode}");
        throw Exception('update worker profile image failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during update worker profile image: $e');
      print(e);
      print(s);
      rethrow;
    }
  }
}
