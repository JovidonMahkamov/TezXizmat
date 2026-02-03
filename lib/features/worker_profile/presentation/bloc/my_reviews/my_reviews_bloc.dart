import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/domain/usecases/my_reviews_use_case.dart';
import 'package:tez_xizmat/features/worker_profile/domain/usecases/worker_edit_profile_use_case.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/my_reviews/my_reviews_state.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_edit_profile/worker_edit_profile_state.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';

class MyReviewsBloc extends Bloc<WorkerProfileEvent, MyReviewsState> {
  final MyReviewsUseCase myReviewsUseCase;

  MyReviewsBloc(this.myReviewsUseCase) : super(MyReviewsInitial()) {
    on<MyReviewsE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(MyReviewsLoading());
    try {
      final result = await myReviewsUseCase();
      emit(MyReviewsSuccess(myReviewsEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(MyReviewsError( message: errorMessage));
    } catch (e) {
      emit(MyReviewsError(message: "Noma’lum xato yuz berdi"));
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