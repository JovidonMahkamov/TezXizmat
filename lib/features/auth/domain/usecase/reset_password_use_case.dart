import 'package:tez_xizmat/features/auth/domain/entities/customer_reset_password_entity.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';

class ResetPasswordUseCase {
  final CustomerRepository customerRepository;

  ResetPasswordUseCase(this.customerRepository);

  Future<CustomerResetPasswordEntity> call({required String email,required String password, required String confirm_password}) async {
    return await customerRepository.resetPassword(email: email, password: password, confirm_password: confirm_password);
  }
}
