import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_reviews_entity.dart';

class GetWorkerReviewsModel extends GetWorkerReviewsEntity {
  const GetWorkerReviewsModel({
    required super.staff,
    required super.rating,
    required super.comment,
    required super.created_at,
    required super.id,
  });

  factory GetWorkerReviewsModel.fromJson(Map<String, dynamic> json) {
    return GetWorkerReviewsModel(
      id: json['id'] ?? 0,
      created_at: json['created_at'] ?? "",
      comment: json['comment'] ?? "",
      rating: json['rating'] ?? 0,
      staff: json['staff'] ?? 0,

    );
  }
}
