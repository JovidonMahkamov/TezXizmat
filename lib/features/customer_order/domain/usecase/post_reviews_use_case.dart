import 'package:tez_xizmat/features/customer_order/domain/entities/post_reviews_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class PostReviewsUseCase {
  final CustomerOrderRepository customerOrderRepository;

  PostReviewsUseCase(this.customerOrderRepository);

  Future<PostReviewsEntity> call({required String text, required int orderId, required int stars}) async {
    return await customerOrderRepository.postReview(orderId: orderId, stars: stars, text: text);
  }
}
