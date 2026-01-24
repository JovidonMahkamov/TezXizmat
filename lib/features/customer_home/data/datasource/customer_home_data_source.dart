import 'package:tez_xizmat/features/customer_home/data/model/customer_get_all_staff_model.dart';
import 'package:tez_xizmat/features/customer_home/data/model/get_worker_info_model.dart';

abstract class CustomerHomeDataSource {
  Future<List<CustomerGetAllStaffModel>> getAllStaff();
  Future<GetWorkerInfoModel> getWorkerInfo({required int id});
}