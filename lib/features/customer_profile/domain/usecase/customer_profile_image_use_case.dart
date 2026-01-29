import 'package:tez_xizmat/features/customer_profile/domain/repository/customer_profile_repository.dart';

import '../entities/customer_profile_image_entity.dart';

class CustomerProfileImageUseCase {
  final CustomerProfileRepository customerProfileRepository;

  CustomerProfileImageUseCase(this.customerProfileRepository);

  Future<CustomerProfileImageEntity> call({required String filePath}) async {
    return await customerProfileRepository.updateImage(filePath: filePath);
  }
}
