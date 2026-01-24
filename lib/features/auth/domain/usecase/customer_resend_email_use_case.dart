import 'package:tez_xizmat/features/auth/domain/entities/customer_resend_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';

class CustomerResendEmailUseCase {
  final CustomerRepository customerRepository;

  CustomerResendEmailUseCase(this.customerRepository);

  Future<CustomerResendEmailEntity> call({required String email}) async {
    return await customerRepository.resendEmail(email: email);
  }
}
