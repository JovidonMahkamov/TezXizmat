import 'package:tez_xizmat/features/auth/domain/entities/customer_login_entity.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';

class CustomerLoginUseCase {
  final CustomerRepository customerRepository;

  CustomerLoginUseCase(this.customerRepository);

  Future<CustomerLoginEntity> call({required String email, required String password}) async {
    return await customerRepository.loginCustomer(email: email, password: password);
  }
}
