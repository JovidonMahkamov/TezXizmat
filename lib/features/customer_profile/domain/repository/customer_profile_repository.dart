import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_profile_entity.dart';
import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_profile_image_entity.dart';
import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_update_profile_entity.dart';

abstract class CustomerProfileRepository{
  Future<CustomerProfileEntity> getProfile();
  Future<CustomerUpdateProfileEntity> updateProfile({required String name, required String surname});
  Future<CustomerProfileImageEntity> updateImage({required String filePath});

}