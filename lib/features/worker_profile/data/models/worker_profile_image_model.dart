import '../../domain/entities/worker_profile_image_entity.dart';

class WorkerProfileImageModel extends WorkerProfileImageEntity {
  const WorkerProfileImageModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.image,
    required super.profession,
    required super.description,
    required super.skillsText,
    required super.priceText,
    required super.freeTimeText,
    required super.avgStar,
    required super.ratingsCount,
    required super.textReviewsCount,
  });

  factory WorkerProfileImageModel.fromJson(Map<String, dynamic> json) {
    return WorkerProfileImageModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      image: json['image'] ?? '',
      profession: json['profession'] ?? '',
      description: json['description'] ?? '',
      skillsText: json['skills_text'] ?? '',
      priceText: json['price_text'] ?? '',
      freeTimeText: json['free_time_text'] ?? '',
      avgStar: json['avg_star'] ?? 0,
      ratingsCount: json['ratings_count'] ?? 0,
      textReviewsCount: json['text_reviews_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'image': image,
      'profession': profession,
      'description': description,
      'skills_text': skillsText,
      'price_text': priceText,
      'free_time_text': freeTimeText,
      'avg_star': avgStar,
      'ratings_count': ratingsCount,
      'text_reviews_count': textReviewsCount,
    };
  }
}