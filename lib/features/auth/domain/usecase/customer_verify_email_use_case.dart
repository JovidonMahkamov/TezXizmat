import 'package:tez_xizmat/features/auth/domain/entities/customer_verify_email_entity.dart';
import 'package:tez_xizmat/features/auth/domain/entities/verify_purpose.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';

class CustomerVerifyEmailUseCase {
  final CustomerRepository customerRepository;

  CustomerVerifyEmailUseCase(this.customerRepository);

  Future<CustomerVerifyEmailEntity> call({required String email,required String password,VerifyPurpose? purpose,}) async {
    return await customerRepository.verifyEmail(email: email, password: password, purpose: purpose,);
  }
}
