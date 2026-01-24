import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_edit_profile_entity.dart';

class WorkerEditProfileModel extends WorkerEditProfileEntity {
  const WorkerEditProfileModel({
    required super.firstName,
    required super.lastName,
    required super.profession,
    required super.description,
    required super.skills,
    required super.price,
    required super.freeTime,
  });

  factory WorkerEditProfileModel.fromJson(Map<String, dynamic> json) {
    return WorkerEditProfileModel(
      firstName: json['first_name']?? "",
      lastName: json['last_name']?? "",
      profession: json['profession']?? "",
      description: json['description']?? "",
      skills: json['skills']?? "",
      price: json['price']?? "",
      freeTime: json['free_time']?? "",
    );
  }
}
