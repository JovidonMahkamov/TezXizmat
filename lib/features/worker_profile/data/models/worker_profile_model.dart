import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_entity.dart';

class WorkerProfileModel extends WorkerProfileEntity {
  const WorkerProfileModel({
    required super.id,
    required super.email,
    required super.image,
    required super.firstName,
    required super.lastName,
    required super.profession,
    required super.comments,
    required super.description,
    required super.skills,
    required super.price,
    required super.freeTime,
    required super.isActive,
  });

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) {
    return WorkerProfileModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      email: json['email']?? "",
      image: json['image']?? "",
      firstName: json['first_name']?? "",
      lastName: json['last_name']?? "",
      profession: json['profession']?? "Sozlamalar bo'limidan ish turingizni kiriting",
      comments: json['comments']?? "",
      description: json['description']?? "Sozlamalar bo'limidan tajribangizni kiriting",
      skills: json['skills']?? "Sozlamalar bo'limidan xizmatlaringizni kiriting",
      price: json['price']?? "Sozlamalar bo'limidan xizmat narxini kiriting",
      freeTime: json['free_time']?? "Sozlamalar bo'limidan ish vaqtingizni kiriting",
      isActive: json['is_active'] == true,
    );
  }
}
