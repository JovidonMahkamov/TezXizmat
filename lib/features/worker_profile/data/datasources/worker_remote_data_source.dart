import 'package:tez_xizmat/features/worker_profile/data/models/worker_edit_profile_model.dart';
import 'package:tez_xizmat/features/worker_profile/data/models/worker_profile_image_model.dart';
import 'package:tez_xizmat/features/worker_profile/data/models/worker_profile_model.dart';

abstract class WorkerRemoteDataSource{
  Future<WorkerProfileModel> getProfile();

  Future<WorkerEditProfileModel> editProfile({
    required String first_name,
    required String last_name,
    required String profession,
    required String description,
    required String skills,
    required String price,
    required String free_time,});
  Future<WorkerProfileImageModel> putImage({required String filePath});

}