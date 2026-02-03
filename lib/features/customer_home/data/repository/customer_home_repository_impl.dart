
import 'package:tez_xizmat/features/customer_home/data/datasource/customer_home_data_source.dart';
import 'package:tez_xizmat/features/customer_home/domain/entities/customer_get_all_staff_entity.dart';
import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_info_entity.dart';
import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_reviews_entity.dart';
import 'package:tez_xizmat/features/customer_home/domain/repository/customer_home_repository.dart';

class CustomerHomeRepositoryImpl implements CustomerHomeRepository {
  final CustomerHomeDataSource customerHomeDataSource;

  CustomerHomeRepositoryImpl({required this.customerHomeDataSource});

  @override
  Future<List<CustomerGetAllStaffEntity>> getAllStaff({required String search}) {
    return customerHomeDataSource.getAllStaff(search: search);
  }

  @override
  Future<GetWorkerInfoEntity> getWorkerInfo({required int id})async {
    return await customerHomeDataSource.getWorkerInfo(id: id);
  }

  @override
  Future<List<GetWorkerReviewsEntity>> getWorkerReviews({required int id}) async{
    return await customerHomeDataSource.getWorkerReviews(id: id);
  }
}