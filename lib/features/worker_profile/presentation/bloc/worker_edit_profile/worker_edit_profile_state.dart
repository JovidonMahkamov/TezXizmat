import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_edit_profile_entity.dart';

abstract class WorkerEditProfileState {
  const WorkerEditProfileState();
}

class WorkerEditProfileInitial extends WorkerEditProfileState {}

class WorkerEditProfileLoading extends WorkerEditProfileState {}

class WorkerEditProfileSuccess extends WorkerEditProfileState {
  final WorkerEditProfileEntity workerEditProfileEntity;

  const WorkerEditProfileSuccess({required this.workerEditProfileEntity});
}

class WorkerEditProfileError extends WorkerEditProfileState {
  final String message;

  const WorkerEditProfileError({required this.message});
}
