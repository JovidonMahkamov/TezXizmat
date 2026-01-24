import 'package:tez_xizmat/features/auth/domain/entities/customer_register_entity.dart';

class CustomerRegisterModel extends CustomerRegisterEntity {
  const CustomerRegisterModel({
    super.detail,
    super.message,
    super.id,
    super.email,
    super.firstName,
    super.lastName,
    super.profession,
    super.comments,
    super.description,
    super.skills,
    super.price,
    super.freeTime,
    super.isActive,
  });

  factory CustomerRegisterModel.fromJson(Map<String, dynamic> json) {
    return CustomerRegisterModel(
      // customer response (message/detail)
      detail: json['detail']?.toString(),
      message: json['message']?.toString(),

      // staff response
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      email: json['email']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      profession: json['profession']?.toString(),
      comments: json['comments']?.toString(),
      description: json['description']?.toString(),
      skills: json['skills']?.toString(),
      price: json['price']?.toString(),
      freeTime: json['free_time']?.toString(),
      isActive: json['is_active'] == true,
    );
  }
}
