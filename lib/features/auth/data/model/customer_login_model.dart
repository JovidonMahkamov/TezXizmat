import 'package:tez_xizmat/features/auth/data/model/login_user_model.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_login_entity.dart';

class CustomerLoginModel extends CustomerLoginEntity {
  const CustomerLoginModel({
    required super.refresh,
    required super.access,
    required super.tokenType,
    required super.user,
  });

  factory CustomerLoginModel.fromJson(Map<String, dynamic> json) {
    final userJson = (json['user'] as Map<String, dynamic>?) ?? {}; //  shu muhim

    return CustomerLoginModel(
      refresh: json['refresh']?.toString() ?? '',
      access: json['access']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'Bearer',
      user: LoginUserModel.fromJson(userJson),
    );
  }
}
