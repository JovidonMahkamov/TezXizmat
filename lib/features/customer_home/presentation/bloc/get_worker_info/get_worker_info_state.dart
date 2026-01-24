import 'package:tez_xizmat/features/customer_home/domain/entities/get_worker_info_entity.dart';

abstract class GetWorkerInfoState {
  const GetWorkerInfoState();
}

class GetWorkerInfoInitial extends GetWorkerInfoState {}

class GetWorkerInfoLoading extends GetWorkerInfoState {}

class GetWorkerInfoSuccess extends GetWorkerInfoState {
  final GetWorkerInfoEntity getWorkerInfoEntity;

  const GetWorkerInfoSuccess({required this.getWorkerInfoEntity});
}

class GetWorkerInfoError extends GetWorkerInfoState {
  final String message;

  const GetWorkerInfoError({required this.message});
}
