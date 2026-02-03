import '../../domain/entities/get_worker_reviews_entity.dart';

class GetWorkerReviewsModel extends GetWorkerReviewsEntity {
  const GetWorkerReviewsModel({
    required super.id,
    required super.orderId,
    required super.stars,
    required super.text,
    required super.createdAt,
    required super.customerId,
    required super.staffId,
    required super.customer,
    required super.staff,
  });

  factory GetWorkerReviewsModel.fromJson(Map<String, dynamic> json) {
    return GetWorkerReviewsModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      stars: json['stars'] ?? 0,
      text: (json['text'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      customerId: json['customer_id'] ?? 0,
      staffId: json['staff_id'] ?? 0,
      customer: json['customer'] is Map<String, dynamic>
          ? (json['customer'] as Map<String, dynamic>)
          : null,
      staff: json['staff'] is Map<String, dynamic>
          ? (json['staff'] as Map<String, dynamic>)
          : null,
    );
  }
}
