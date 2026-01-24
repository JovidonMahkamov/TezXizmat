import 'package:tez_xizmat/features/customer_home/domain/entities/customer_get_all_staff_entity.dart';
import 'package:tez_xizmat/features/customer_home/domain/repository/customer_home_repository.dart';

class CustomerGetAllStaffUseCase {
  final CustomerHomeRepository customerHomeRepository;

  CustomerGetAllStaffUseCase(this.customerHomeRepository);

  Future<List<CustomerGetAllStaffEntity>> call() async {
    return await customerHomeRepository.getAllStaff();
  }
}