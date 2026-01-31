import 'package:tez_xizmat/features/auth/domain/entities/customer_login_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_register_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_resend_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_reset_password_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_send_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_verify_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/verify_purpose.dart';

abstract class CustomerRepository {
  Future<CustomerSendEmailEntity> sendEmail({required String email});
  Future<CustomerVerifyEmailEntity> verifyEmail({required String email,required String password, required VerifyPurpose purpose,});
  Future<CustomerRegisterEntity> registerCustomer({required String name,required String surname, required String email, required String password, required String confirm_password});
  Future<CustomerLoginEntity> loginCustomer({required String email,required String password});
  Future<CustomerResendEmailEntity> resendEmail({required String email,});
  Future<CustomerResetPasswordEntity> resetPassword({required String email,required String password, required String confirm_password});
}
