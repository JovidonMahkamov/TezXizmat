import 'package:tez_xizmat/features/customer_home/domain/entities/customer_get_all_staff_entity.dart';

class CustomerGetAllStaffModel extends CustomerGetAllStaffEntity {
  const CustomerGetAllStaffModel({
    required super.avg_rating,
    required super.free_time,
    required super.image,
    required super.first_name,
    required super.last_name,
    required super.id,
    required super.price,
    required super.profession,
    required super.ratings_count,
  });

  factory CustomerGetAllStaffModel.fromJson(Map<String, dynamic> json) {
    return CustomerGetAllStaffModel(
      id: json['id'] ?? 0,
      avg_rating: json['avg_rating'] ?? 0.0,
      profession: json['profession'] ?? "",
      price: json['price'] ?? "",
      first_name: json['first_name'] ?? "",
      last_name: json['last_name'] ?? "",
      image: json['image'] ?? "",
      free_time: json['free_time'] ?? "",
      ratings_count: json['ratings_count'] ?? 0,
    );
  }
}
