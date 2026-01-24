import 'package:tez_xizmat/features/worker_profile/data/datasources/worker_remote_data_source.dart';
import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_edit_profile_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_image_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/repositories/worker_repository.dart';

class  WorkerProfileRepositoryImpl implements WorkerRepository {
  final WorkerRemoteDataSource workerRemoteDataSource;

  WorkerProfileRepositoryImpl({required this.workerRemoteDataSource});

  @override
  Future<WorkerProfileEntity> getProfile() {
    return workerRemoteDataSource.getProfile();
  }

  @override
  Future<WorkerEditProfileEntity> editProfile({required String first_name, required String last_name, required String profession, required String description, required String skills, required String price, required String free_time}) {
   return workerRemoteDataSource.editProfile(first_name: first_name, last_name: last_name, profession: profession,  description: description, skills: skills, price: price, free_time: free_time);
  }

  @override
  Future<WorkerProfileImageEntity> putImage({required String filePath}) {
    return workerRemoteDataSource.putImage(filePath: filePath);
  }
}