import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_update_profile_entity.dart';
import 'package:tez_xizmat/features/customer_profile/domain/repository/customer_profile_repository.dart';

class CustomerUpdateProfileUseCase{
  final CustomerProfileRepository customerProfileRepository;
  CustomerUpdateProfileUseCase(this.customerProfileRepository);

  Future<CustomerUpdateProfileEntity> call({required String name, required String surname}) async{
    return await customerProfileRepository.updateProfile(name: name, surname: surname);
  }
}