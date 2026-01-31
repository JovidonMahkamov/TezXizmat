import 'package:tez_xizmat/features/auth/domain/entities/customer_register_entity.dart';

class CustomerRegisterModel extends CustomerRegisterEntity {
  const CustomerRegisterModel({
    super.id,
    super.email,
    super.firstName,
    super.lastName,
    super.profession,
    super.createdAt,
    super.description,
    super.skills,
    super.price,
    super.freeTime,
    super.isActive,
    super.image,
  });

  factory CustomerRegisterModel.fromJson(Map<String, dynamic> json) {
    return CustomerRegisterModel(
      // staff and customer response
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      email: json['email']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      profession: json['profession']?.toString(),
      createdAt: json['created_at']?.toString(),
      description: json['description']?.toString(),
      skills: json['skills_text']?.toString(),
      price: json['price_text']?.toString(),
      freeTime: json['free_time_text']?.toString(),
      image: json['image']?.toString(),
      isActive: json['is_email_verified'] == true,
    );
  }
}
