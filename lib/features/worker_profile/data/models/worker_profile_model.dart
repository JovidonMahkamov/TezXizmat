import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_entity.dart';

class WorkerProfileModel extends WorkerProfileEntity {
  const WorkerProfileModel({
    required super.id,
    required super.email,
    required super.image,
    required super.firstName,
    required super.lastName,
    required super.profession,
    required super.createdAt,
    required super.description,
    required super.freeTimeText,
    required super.isEmailVerified,
    required super.priceText,
    required super.skillsText,
  });

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) {
    return WorkerProfileModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      email: json['email']?? "",
      image: json['image']?? "",
      firstName: json['first_name']?? "",
      lastName: json['last_name']?? "",
      profession: json['profession']?? "",
      freeTimeText: json['free_time_text']?? "",
      description: json['description']?? "",
      isEmailVerified: json['is_email_verified'] == true,
      priceText: json['price_text']?? "",
      skillsText: json['skills_text']?? "",
      createdAt: json['created_at'] ?? "",
    );
  }
}
