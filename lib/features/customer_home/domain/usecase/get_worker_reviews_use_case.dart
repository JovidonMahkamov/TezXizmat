import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_reviews_entity.dart';
import 'package:tez_xizmat/features/customer_home/domain/repository/customer_home_repository.dart';

class GetWorkerReviewsUseCase {
  final CustomerHomeRepository customerHomeRepository;

  GetWorkerReviewsUseCase(this.customerHomeRepository);

  Future<List<GetWorkerReviewsEntity>> call({required int id}) async {
    return await customerHomeRepository.getWorkerReviews(id: id);
  }
}