import 'package:tez_xizmat/features/auth/data/model/customer_register_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_send_email_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_verify_email_model.dart';

abstract class CustomerRemoteDataSource{
Future<CustomerSendEmailModel> sendEmail({required String email});
Future<CustomerVerifyEmailModel> verifyEmail({required String email,required String password});
Future<CustomerRegisterModel> registerCustomer({required String name,required String surname, required String email, required String password, required String confirm_password});
}