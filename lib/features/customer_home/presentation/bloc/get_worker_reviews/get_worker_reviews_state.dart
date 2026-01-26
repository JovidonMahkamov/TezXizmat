import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_reviews_entity.dart';

abstract class GetWorkerReviewsState {
  const GetWorkerReviewsState();
}

class GetWorkerReviewsInitial extends GetWorkerReviewsState {}

class GetWorkerReviewsLoading extends GetWorkerReviewsState {}

class GetWorkerReviewsSuccess extends GetWorkerReviewsState {
  final List<GetWorkerReviewsEntity> getWorkerReviewsEntity;

  const GetWorkerReviewsSuccess({required this.getWorkerReviewsEntity});
}

class GetWorkerReviewsError extends GetWorkerReviewsState {
  final String message;

  const GetWorkerReviewsError({required this.message});
}
