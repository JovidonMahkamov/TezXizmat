import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_profile_image_entity.dart';
class CustomerProfileImageModel extends CustomerProfileImageEntity {
  const CustomerProfileImageModel({required super.image});

  factory CustomerProfileImageModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileImageModel(
      image: (json['image'] ?? '') as String,
    );
  }
}
