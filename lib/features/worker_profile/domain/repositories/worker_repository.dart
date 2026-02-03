import 'package:tez_xizmat/features/worker_profile/domain/entities/my_reviews_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_edit_profile_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_entity.dart';
import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_image_entity.dart';

abstract class WorkerRepository {
  Future<WorkerProfileEntity> getProfile();

  Future<WorkerEditProfileEntity> editProfile({
    required String first_name,
    required String last_name,
    required String profession,
    required String description,
    required String skills_text,
    required String price_text,
    required String free_time_text,
  });

  Future<WorkerProfileImageEntity> putImage({required String filePath});

  Future<List<MyReviewsEntity>> getMyReviews();
}
