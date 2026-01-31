import 'package:tez_xizmat/core/network/customer_dio_client.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/worker_profile/data/datasources/worker_remote_data_source.dart';
import 'package:tez_xizmat/features/worker_profile/data/models/worker_edit_profile_model.dart';
import 'package:tez_xizmat/features/worker_profile/data/models/worker_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:tez_xizmat/features/worker_profile/data/models/worker_profile_image_model.dart';
import '../../../../core/network/staff_api_urls.dart';


class WorkerRemoteDataSourceImpl implements WorkerRemoteDataSource {
  final StaffDioClient staffDioClient;
  final CustomerDioClient customerDioClient;
  final AuthLocalDataSource local;

  WorkerRemoteDataSourceImpl(this.customerDioClient, this.staffDioClient, this.local);

  @override
  Future<WorkerProfileModel> getProfile() async{
    try {

      final response = await customerDioClient.get(StaffApiUrls.getStaffProfile);
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('get worker profile successful: ${response.data}');
        return WorkerProfileModel.fromJson(response.data);
      } else {
        LoggerService.warning("get worker profile failed: ${response.statusCode}");
        throw Exception('get worker profile failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during get worker profile: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<WorkerEditProfileModel> editProfile({required String first_name, required String last_name, required String profession, required String description, required String skills_text, required String price_text, required String free_time_text}) async{
    try {

      final response = await customerDioClient.patch(
        StaffApiUrls.updateStaffProfile,
          data: {
            "first_name": first_name,
            "last_name": last_name,
            "profession": profession,
            "description": description,
            "skills_text": skills_text,
            "price_text": price_text,
            "free_time_text": free_time_text,
          }

      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('edit worker profile successful: ${response.data}');
        return WorkerEditProfileModel.fromJson(response.data);
      } else {
        LoggerService.warning("edit worker profile failed: ${response.statusCode}");
        throw Exception('edit worker profile failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during edit worker profile: $e');
      print(e);
      print(s);
      rethrow;
    }
  }
  @override
  Future<WorkerProfileImageModel> putImage({required String filePath}) async {
    try {
      final fileName = p.basename(filePath);

      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      final response = await customerDioClient.put(
        StaffApiUrls.staffProfileImage,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('update worker profile image successful: ${response.data}');
        return WorkerProfileImageModel.fromJson(response.data);
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