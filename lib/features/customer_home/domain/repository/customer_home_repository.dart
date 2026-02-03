import 'package:tez_xizmat/features/customer_home/domain/entities/customer_get_all_staff_entity.dart';
import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_info_entity.dart';
import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_reviews_entity.dart';

abstract class CustomerHomeRepository {
  Future<List<CustomerGetAllStaffEntity>> getAllStaff({required String search});

  Future<GetWorkerInfoEntity>getWorkerInfo({required int id});
  Future<List<GetWorkerReviewsEntity>>getWorkerReviews({required int id});
}