import 'package:tez_xizmat/core/network/api_urls.dart';
import 'package:tez_xizmat/core/network/dio_client.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/worker_profile/data/datasources/worker_remote_data_source.dart';
import 'package:tez_xizmat/features/worker_profile/data/models/worker_edit_profile_model.dart';
import 'package:tez_xizmat/features/worker_profile/data/models/worker_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:tez_xizmat/features/worker_profile/data/models/worker_profile_image_model.dart';


class WorkerRemoteDataSourceImpl implements WorkerRemoteDataSource {
  final DioClient dioClient;
  final AuthLocalDataSource local;

  WorkerRemoteDataSourceImpl( this.dioClient,  this.local);

  @override
  Future<WorkerProfileModel> getProfile() async{
    try {

      final response = await dioClient.get(ApiUrls.getStaffProfile);
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
  Future<WorkerEditProfileModel> editProfile({required String first_name, required String last_name, required String profession, required String description, required String skills, required String price, required String free_time}) async{
    try {

      final response = await dioClient.patch(
        ApiUrls.updateStaffProfile,
        data: {
          "first_name": first_name,
          "last_name": last_name,
          "profession": profession,
          "description": description,
          "skills": skills,
          "price": price,
          "free_time": free_time,
        },
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

      final response = await dioClient.put(
        ApiUrls.staffProfileImage,
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