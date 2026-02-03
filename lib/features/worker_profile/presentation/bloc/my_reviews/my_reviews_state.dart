import 'package:tez_xizmat/features/worker_profile/domain/entities/my_reviews_entity.dart';

abstract class MyReviewsState {
  const MyReviewsState();
}

class MyReviewsInitial extends MyReviewsState {}

class MyReviewsLoading extends MyReviewsState {}

class MyReviewsSuccess extends MyReviewsState {
  final List <MyReviewsEntity> myReviewsEntity;

  const MyReviewsSuccess({required this.myReviewsEntity});
}

class MyReviewsError extends MyReviewsState {
  final String message;

  const MyReviewsError({required this.message});
}
