import '../../domain/entities/my_reviews_entity.dart';

class MyReviewsModel extends MyReviewsEntity {
  const MyReviewsModel({
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

  factory MyReviewsModel.fromJson(Map<String, dynamic> json) {
    return MyReviewsModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      stars: json['stars'] ?? 0,
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
      customerId: json['customer_id'] ?? 0,
      staffId: json['staff_id'] ?? 0,
      customer: json['customer'] as Map<String, dynamic>,
      staff: json['staff'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'stars': stars,
      'text': text,
      'created_at': createdAt,
      'customer_id': customerId,
      'staff_id': staffId,
      'customer': customer,
      'staff': staff,
    };
  }
}
