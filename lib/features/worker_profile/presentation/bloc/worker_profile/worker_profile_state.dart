import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_entity.dart';

abstract class  WorkerProfileState{
  const WorkerProfileState();
}

class WorkerProfileInitial extends WorkerProfileState {}

class WorkerProfileLoading extends WorkerProfileState {}

class WorkerProfileSuccess extends WorkerProfileState {
  final WorkerProfileEntity workerProfileEntity;


  const WorkerProfileSuccess({required this.workerProfileEntity,});
}

class WorkerProfileError extends WorkerProfileState {
  final String message;

  const WorkerProfileError({required this.message});
}
