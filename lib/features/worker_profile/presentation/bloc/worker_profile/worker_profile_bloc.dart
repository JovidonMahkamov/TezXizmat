import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/domain/usecases/worker_profile_use_case.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_state.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';

class WorkerProfileBloc extends Bloc<WorkerProfileEvent, WorkerProfileState> {
  final WorkerProfileUseCase workerProfileUseCase;

  WorkerProfileBloc(this.workerProfileUseCase) : super(WorkerProfileInitial()) {
    on<WorkerProfileE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(WorkerProfileLoading());
    try {
      final result = await workerProfileUseCase();
      emit(WorkerProfileSuccess(workerProfileEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(WorkerProfileError( message: errorMessage));
    } catch (e) {
      emit(WorkerProfileError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return "Kiritilgan email tasdiqlanmagan";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }

    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }}