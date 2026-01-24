import 'package:tez_xizmat/features/customer_profile/data/datasource/customer_profile_data_source.dart';
import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_profile_entity.dart';
import 'package:tez_xizmat/features/customer_profile/domain/entities/customer_update_profile_entity.dart';
import 'package:tez_xizmat/features/customer_profile/domain/repository/customer_profile_repository.dart';

class CustomerProfileRepositoryImpl implements CustomerProfileRepository {
  final CustomerProfileDataSource customerProfileDataSource;

  CustomerProfileRepositoryImpl({required this.customerProfileDataSource});

  @override
  Future<CustomerProfileEntity> getProfile() {
    return customerProfileDataSource.getProfile();
  }

  @override
  Future<CustomerUpdateProfileEntity> updateProfile({
    required String name,
    required String surname,
  }) {
    return customerProfileDataSource.updateProfile(
      name: name,
      surname: surname,
    );
  }
}
