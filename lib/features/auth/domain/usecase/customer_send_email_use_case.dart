import 'package:tez_xizmat/features/auth/domain/entities/customer_send_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';

class CustomerSendEmailUseCase {
  final CustomerRepository customerRepository;

  CustomerSendEmailUseCase(this.customerRepository);

  Future<CustomerSendEmailEntity> call({required String email}) async {
    return await customerRepository.sendEmail(email: email);
  }
}
