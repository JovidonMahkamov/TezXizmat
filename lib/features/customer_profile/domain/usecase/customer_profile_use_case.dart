import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_profile_entity.dart';
import 'package:tez_xizmat/features/customer_profile/domain/repository/customer_profile_repository.dart';

class CustomerProfileUseCase{
  final CustomerProfileRepository customerProfileRepository;
  CustomerProfileUseCase(this.customerProfileRepository);

  Future<CustomerProfileEntity> call() async{
    return await customerProfileRepository.getProfile();
  }
}