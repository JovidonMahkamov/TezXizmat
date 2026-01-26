import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_info_entity.dart';

class GetWorkerInfoModel extends GetWorkerInfoEntity {
  const GetWorkerInfoModel({
    required super.id, required super.avg_rating, required super.description, required super.first_name, required super.last_name, required super.email, required super.free_time, required super.image, required super.price, required super.profession, required super.ratings_count, required super.reviews_text_count, required super.skills,
  });
  factory GetWorkerInfoModel.fromJson(Map<String, dynamic> json) {
    return GetWorkerInfoModel(
      id: json['id'],
      description: json['description'],
      skills: json['skills'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      price: json['price'],
      avg_rating: json['avg_rating']?? 0.0,
      image: (json['image'] ?? '') as String,
      profession: json['profession'],
      free_time: json['free_time'],
      ratings_count: json['ratings_count'],
      reviews_text_count: json['reviews_text_count'],
    );
  }
}
