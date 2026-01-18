import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/remote/customer_remote_data_source.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_login_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_register_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_send_email_model.dart';
import 'package:tez_xizmat/features/auth/data/model/customer_verify_email_model.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';

import '../../../../../core/network/api_urls.dart';
import '../../../../../core/network/dio_client.dart';

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final DioClient dioClient = DioClient();
  final AuthLocalDataSource local;

  CustomerRemoteDataSourceImpl({required this.local});

  bool get _isStaff => (local.getRole() ?? 'customer') == 'staff';

  @override
  Future<CustomerSendEmailModel> sendEmail({required String email}) async {
    try {
      final url = _isStaff ? ApiUrls.sendEmailStaff : ApiUrls.sendEmail;

      final response = await dioClient.post(url, data: {'email': email});
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('send code successful: ${response.data}');
        return CustomerSendEmailModel.fromJson(response.data);
      } else {
        LoggerService.warning("send code failed: ${response.statusCode}");
        throw Exception('send code failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during user login: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<CustomerVerifyEmailModel> verifyEmail({
    required String email,
    required String password,
  }) async {
    try {
      final url = _isStaff ? ApiUrls.verifyEmailStaff : ApiUrls.verifyEmail;

      final response = await dioClient.post(
        url,
        data: {'email': email, 'code': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('verify email successful: ${response.data}');
        return CustomerVerifyEmailModel.fromJson(response.data);
      } else {
        LoggerService.warning("verify email failed: ${response.statusCode}");
        throw Exception('verify email failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during user verify email: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<CustomerRegisterModel> registerCustomer({
    required String name,
    required String surname,
    required String email,
    required String password,
    required String confirm_password,
  }) async {
    try {
      final url = _isStaff ? ApiUrls.registerStaff : ApiUrls.registerCustomer;

      final response = await dioClient.post(
        url,
        data: {
          'email': email,
          'password': password,
          'password2': confirm_password,
          'first_name': name,
          'last_name': surname,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('customer register successful: ${response.data}');
        return CustomerRegisterModel.fromJson(response.data);
      } else {
        LoggerService.warning(
          "customer register failed: ${response.statusCode}",
        );
        throw Exception('customer register failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during customer register: $e');
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<CustomerLoginModel> loginCustomer({
    required String email,
    required String password,
  }) async {
    try {
      final url = _isStaff ? ApiUrls.loginStaff : ApiUrls.loginCustomer;

      final response = await dioClient.post(
        url,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('customer login successful: ${response.data}');
        return CustomerLoginModel.fromJson(response.data);
      } else {
        LoggerService.warning("customer login failed: ${response.statusCode}");
        throw Exception('customer login failed: ${response.statusCode}');
      }
    } catch (e, s) {
      LoggerService.error('Error during customer login: $e');
      print(e);
      print(s);
      rethrow;
    }
  }
}
