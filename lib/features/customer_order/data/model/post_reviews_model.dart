import 'package:tez_xizmat/features/customer_order/domain/entities/post_reviews_entity.dart';

class PostReviewsModel extends PostReviewsEntity {
  const PostReviewsModel({
    required super.id,
    required super.createdAt,
    required super.customer,
    required super.customerId,
    required super.orderId,
    required super.staff,
    required super.staffId,
    required super.stars,
    required super.text,
  });

  static String _nameFromJson(dynamic v) {
    if (v is Map<String, dynamic>) {
      final first = (v['first_name'] ?? '').toString();
      final last = (v['last_name'] ?? '').toString();
      final full = ('$first $last').trim();
      return full.isEmpty ? '' : full;
    }
    return v?.toString() ?? '';
  }

  factory PostReviewsModel.fromJson(Map<String, dynamic> json) {
    return PostReviewsModel(
      id: json['id'] ?? 0,
      createdAt: (json['created_at'] ?? '').toString(),
      customerId: json['customer_id'] ?? 0,
      customer: _nameFromJson(json['customer']), //  FIX
      orderId: json['order_id'] ?? 0,
      staff: _nameFromJson(json['staff']),       //  FIX
      staffId: json['staff_id'] ?? 0,
      stars: json['stars'] ?? 0,
      text: (json['text'] ?? '').toString(),
    );
  }
}
