import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_home/domain/usecase/get_worker_reviews_use_case.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_home_event.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/get_worker_reviews/get_worker_reviews_state.dart';

class GetWorkerReviewsBloc extends Bloc<CustomerHomeEvent, GetWorkerReviewsState> {
  final GetWorkerReviewsUseCase getWorkerReviewsUseCase;

  GetWorkerReviewsBloc(this.getWorkerReviewsUseCase) : super(GetWorkerReviewsInitial()) {
    on<GetWorkerReviewsE>(onLogInUser);
  }

  Future<void> onLogInUser(event, emit) async {
    emit(GetWorkerReviewsLoading());
    try {
      final result = await getWorkerReviewsUseCase(
        id: event.id,
      );
      emit(GetWorkerReviewsSuccess(getWorkerReviewsEntity: result));
    } on DioException catch (e) {
      String errorMessage = _mapDioErrorToMessage(e);
      emit(GetWorkerReviewsError( message: errorMessage));
    } catch (e) {
      emit(GetWorkerReviewsError(message: "Noma’lum xato yuz berdi"));
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