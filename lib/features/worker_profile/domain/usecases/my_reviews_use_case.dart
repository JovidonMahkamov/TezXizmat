import 'package:tez_xizmat/features/worker_profile/domain/entities/my_reviews_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/repositories/worker_repository.dart';

class MyReviewsUseCase {
  final WorkerRepository workerRepository;

  MyReviewsUseCase(this.workerRepository);

  Future<List<MyReviewsEntity>> call() async {
    return await workerRepository.getMyReviews();
  }
}
