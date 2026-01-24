import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/domain/usecases/worker_edit_profile_use_case.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_edit_profile/worker_edit_profile_state.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';

class WorkerEditProfileBloc extends Bloc<WorkerProfileEvent, WorkerEditProfileState> {
  final WorkerEditProfileUseCase workerEditProfileUseCase;

  WorkerEditProfileBloc(this.workerEditProfileUseCase) : super(WorkerEditProfileInitial()) {
    on<WorkerEditProfile>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(WorkerEditProfileLoading());
    try {
      final result = await workerEditProfileUseCase(
        first_name: event.first_name,
        last_name: event.last_name,
        profession: event.profession,
        description: event.description,
        skills: event.skills,
        price: event.price,
        free_time: event.free_time,
      );
      emit(WorkerEditProfileSuccess(workerEditProfileEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(WorkerEditProfileError( message: errorMessage));
    } catch (e) {
      emit(WorkerEditProfileError(message: "Noma’lum xato yuz berdi"));
    }
  }

  String _mapDioErrorToMessage(DioException error) {
    if (error.type == DioExceptionType.unknown &&
        error.error is SocketException) {
      return "Internet ulanmagan. Iltimos, tarmoqni tekshiring.";
    } else if (error.response?.statusCode == 400) {
      return "Kiritilgan parol xato,yoki email tasdiqlanmagan";
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return "So‘rov vaqtida javob kelmadi. Keyinroq urinib ko‘ring.";
    } else if (error.response?.statusCode == 500) {
      return "Serverda nosozlik bor. Iltimos, keyinroq urinib ko‘ring.";
    }

    return "Noma’lum xato yuz berdi. Iltimos, qayta urinib ko‘ring.";
  }}