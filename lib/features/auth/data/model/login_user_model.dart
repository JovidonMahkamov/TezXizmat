import 'package:tez_xizmat/features/auth/domain/entities/login_user_entity.dart';

class LoginUserModel extends LoginUserEntity {
  const LoginUserModel({
    super.id,
    super.firstName,
    super.lastName,
    super.email,
    super.image,
    super.profession,
    super.description,
    super.skillsText,
    super.priceText,
    super.freeTimeText,
    super.isEmailVerified,
    required super.createdAt,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    // created_at null bo‘lib qolsa yiqilmasin
    final createdAtRaw = json['created_at']?.toString();
    final createdAtParsed = createdAtRaw != null ? DateTime.tryParse(createdAtRaw) : null;

    return LoginUserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      email: json['email']?.toString(),
      image: json['image']?.toString(), // null bo‘lsa null qoladi
      profession: json['profession']?.toString(),
      description: json['description']?.toString(),
      skillsText: json['skills_text']?.toString(),
      priceText: json['price_text']?.toString(),
      freeTimeText: json['free_time_text']?.toString(),
      isEmailVerified: json['is_email_verified'] == true,
      createdAt: createdAtParsed ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'image': image,
      'profession': profession,
      'description': description,
      'skills_text': skillsText,
      'price_text': priceText,
      'free_time_text': freeTimeText,
      'is_email_verified': isEmailVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
