import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_image_entity.dart';

abstract class  WorkerProfileImageState{
  const WorkerProfileImageState();
}

class WorkerProfileImageInitial extends WorkerProfileImageState {}

class WorkerProfileImageLoading extends WorkerProfileImageState {}

class WorkerProfileImageSuccess extends WorkerProfileImageState {
  final WorkerProfileImageEntity workerProfileImageEntity;


  const WorkerProfileImageSuccess({required this.workerProfileImageEntity,});
}

class WorkerProfileImageError extends WorkerProfileImageState {
  final String message;

  const WorkerProfileImageError({required this.message});
}
