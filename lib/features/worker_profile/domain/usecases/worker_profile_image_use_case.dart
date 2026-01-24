import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_image_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/repositories/worker_repository.dart';

class WorkerProfileImageUseCase {
  final WorkerRepository workerRepository;

  WorkerProfileImageUseCase(this.workerRepository);

  Future<WorkerProfileImageEntity> call({required String filePath}) async {
    return await workerRepository.putImage(filePath: filePath);
  }
}
