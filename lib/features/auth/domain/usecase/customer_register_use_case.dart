import 'package:tez_xizmat/features/auth/domain/entities/customer_register_entity.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';

class CustomerRegisterUseCase {
  final CustomerRepository customerRepository;

  CustomerRegisterUseCase(this.customerRepository);

  Future<CustomerRegisterEntity> call({required String name, required String surname, required String email,required String password, required String confirm_password}) async {
    return await customerRepository.registerCustomer(name: name, surname: surname, email: email, password: password, confirm_password: confirm_password);
  }
}
