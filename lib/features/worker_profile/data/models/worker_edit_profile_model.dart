import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_edit_profile_entity.dart';

class WorkerEditProfileModel extends WorkerEditProfileEntity {
  const WorkerEditProfileModel({
    required super.firstName,
    required super.lastName,
    required super.profession,
    required super.description,
    required super.skillsText,
    required super.priceText,
    required super.freeTimeText,
  });

  factory WorkerEditProfileModel.fromJson(Map<String, dynamic> json) {
    return WorkerEditProfileModel(
      firstName: json['first_name']?? "",
      lastName: json['last_name']?? "",
      profession: json['profession']?? "",
      description: json['description']?? "",
      skillsText: json['skills_text']?? "",
      priceText: json['price_text']?? "",
      freeTimeText: json['free_time_text']?? "",
    );
  }
}
