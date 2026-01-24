import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_edit_profile_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/repositories/worker_repository.dart';

class WorkerEditProfileUseCase {
  final WorkerRepository workerRepository;

  WorkerEditProfileUseCase(this.workerRepository);

  Future<WorkerEditProfileEntity> call({
    required String first_name,
    required String last_name,
    required String profession,
    required String description,
    required String skills,
    required String price,
    required String free_time,
  }) async {
    return await workerRepository.editProfile(
      first_name: first_name,
      last_name: last_name,
      profession: profession,
      description: description,
      skills: skills,
      price: price,
      free_time: free_time,
    );
  }
}
