import 'package:tez_xizmat/features/auth/data/model/customer_login_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_register_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_resend_email_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_reset_password_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_send_email_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_verify_email_model.dart';
import 'package:tez_xizmat/features/auth/domain/entities/verify_purpose.dart';

abstract class CustomerRemoteDataSource{
Future<CustomerSendEmailModel> sendEmail({required String email});
Future<CustomerVerifyEmailModel> verifyEmail({required String email,required String password, VerifyPurpose? purpose,});
Future<CustomerRegisterModel> registerCustomer({required String name,required String surname, required String email, required String password, required String confirm_password});
Future<CustomerLoginModel> loginCustomer({required String email,required String password,});
Future<CustomerResendEmailModel> resendEmail({required String email});
Future<CustomerResetPasswordModel> resetPassword({required String email,required String password, required String confirm_password});
}