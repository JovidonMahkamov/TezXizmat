import 'package:tez_xizmat/features/auth/domain/entities/login_user_entity.dart';

class CustomerLoginEntity {
  final String refresh;
  final String access;
  final String tokenType;
  final LoginUserEntity user;

  const CustomerLoginEntity({
    required this.refresh,
    required  this.access,
    required  this.tokenType,
    required  this.user
  });
}
