import 'package:tez_xizmat/features/customer_profile/data/model/customer_profile_model.dart';
import 'package:tez_xizmat/features/customer_profile/data/model/customer_update_profile_model.dart';

abstract class CustomerProfileDataSource{
  Future<CustomerProfileModel> getProfile();
  Future<CustomerUpdateProfileModel> updateProfile({required String name, required String surname});
}