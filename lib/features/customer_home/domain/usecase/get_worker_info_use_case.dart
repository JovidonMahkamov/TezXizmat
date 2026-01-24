import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_info_entity.dart';
import 'package:tez_xizmat/features/customer_home/domain/repository/customer_home_repository.dart';

class GetWorkerInfoUseCase {
  final CustomerHomeRepository customerHomeRepository;

  GetWorkerInfoUseCase(this.customerHomeRepository);

  Future<GetWorkerInfoEntity> call({required int id}) async {
    return await customerHomeRepository.getWorkerInfo(id: id);
  }
}