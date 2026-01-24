import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/repositories/worker_repository.dart';

class WorkerProfileUseCase {
  final WorkerRepository workerRepository;

  WorkerProfileUseCase(this.workerRepository);

  Future<WorkerProfileEntity> call() async {
    return await workerRepository.getProfile();
  }
}
