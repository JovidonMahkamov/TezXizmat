import 'package:tez_xizmat/features/auth/data/datasource/remote/customer_remote_data_source.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_login_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_register_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_resend_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_reset_password_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_send_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/customer_verify_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';
import 'package:tez_xizmat/features/auth/domain/entities/verify_purpose.dart';


class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource customerRemoteDataSource;

  CustomerRepositoryImpl({required this.customerRemoteDataSource});

  @override
  Future<CustomerSendEmailEntity> sendEmail({required String email,}) {
    return customerRemoteDataSource.sendEmail(email: email, );
  }

  @override
  Future<CustomerVerifyEmailEntity> verifyEmail({required String email, required String password, VerifyPurpose? purpose,}) {
    return customerRemoteDataSource.verifyEmail(email: email, password: password, purpose: purpose);
  }

  @override
  Future<CustomerRegisterEntity> registerCustomer({required String name, required String surname, required String email, required String password, required String confirm_password}) {
    return customerRemoteDataSource.registerCustomer(name: name, surname: surname, email: email, password: password, confirm_password: confirm_password);
  }

  @override
  Future<CustomerLoginEntity> loginCustomer({required String email, required String password,}) {
    return customerRemoteDataSource.loginCustomer( email: email, password: password,);
  }

  @override
  Future<CustomerResendEmailEntity> resendEmail({required String email}) {
    return customerRemoteDataSource.resendEmail(email: email);
  }

  @override
  Future<CustomerResetPasswordEntity> resetPassword({required String email, required String password, required String confirm_password}) {
    return customerRemoteDataSource.resetPassword(email: email, password: password, confirm_password: confirm_password);
  }
}
