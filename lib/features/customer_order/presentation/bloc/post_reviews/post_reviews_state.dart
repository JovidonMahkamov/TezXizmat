import 'package:tez_xizmat/features/customer_order/domain/entities/post_reviews_entity.dart';

abstract class PostReviewsState {
  const PostReviewsState();
}

class PostReviewsInitial extends PostReviewsState {}

class PostReviewsLoading extends PostReviewsState {}

class PostReviewsSuccess extends PostReviewsState {
  final PostReviewsEntity postReviewsEntity;

  const PostReviewsSuccess({required this.postReviewsEntity});
}

class PostReviewsError extends PostReviewsState {
  final String message;

  const PostReviewsError({required this.message});
}
