import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_info_entity.dart';

class GetWorkerInfoModel extends GetWorkerInfoEntity {
  const GetWorkerInfoModel({
    required super.id,
    required super.avgStar,
    required super.description,
    required super.firstName,
    required super.lastName,
    required super.freeTimeText,
    required super.image,
    required super.priceText,
    required super.profession,
    required super.ratingsCount,
    required super.textReviewsCount,
    required super.skillsText,
  });

  factory GetWorkerInfoModel.fromJson(Map<String, dynamic> json) {
    return GetWorkerInfoModel(
      id: json['id'],
      description: json['description'],
      skillsText: json['skills_text'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      priceText: json['price_text'],
      avgStar: json['avg_star'] ?? 0.0,
      image: (json['image'] ?? '') as String,
      profession: json['profession'],
      freeTimeText: json['free_time_text'],
      ratingsCount: json['ratings_count'],
      textReviewsCount: json['text_reviews_count'],
    );
  }
}
