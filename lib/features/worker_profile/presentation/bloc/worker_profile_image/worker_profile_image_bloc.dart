import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/domain/usecases/worker_profile_image_use_case.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_state.dart';

class WorkerProfileImageBloc extends Bloc<WorkerProfileEvent, WorkerProfileImageState> {
  final WorkerProfileImageUseCase workerProfileImageUseCase;

  WorkerProfileImageBloc(this.workerProfileImageUseCase) : super(WorkerProfileImageInitial()) {
    on<WorkerProfileImage>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(WorkerProfileImageLoading());
    try {
      final result = await workerProfileImageUseCase(
        filePath: event.filePath
      );
      emit(WorkerProfileImageSuccess(workerProfileImageEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(WorkerProfileImageError( message: errorMessage));
    } catch (e) {
      emit(WorkerProfileImageError(message: "Noma’lum xato yuz berdi"));
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