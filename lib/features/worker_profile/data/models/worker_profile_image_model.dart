
import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_image_entity.dart';

class WorkerProfileImageModel extends WorkerProfileImageEntity {
  const WorkerProfileImageModel({required super.image});

  factory WorkerProfileImageModel.fromJson(Map<String, dynamic> json) {
    return WorkerProfileImageModel(
      image: (json['image'] ?? '') as String,
    );
  }
}
