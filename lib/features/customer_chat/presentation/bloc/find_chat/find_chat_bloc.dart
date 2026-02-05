import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/find_chat_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/find_chat/find_chat_state.dart';


class FindChatBloc extends Bloc<ChatEvent, FindChatState> {
  final FindChatUseCase findChatUseCase;

  FindChatBloc({required this.findChatUseCase}) : super(const FindChatInitial()) {
    on<FindChatStaffE>(_findAsStaff);
    on<FindChatCustomerE>(_findAsCustomer);
  }

  Future<void> _findAsStaff(
      FindChatStaffE event,
      Emitter<FindChatState> emit,
      ) async {
    emit( FindChatLoading());

    try {
      final room = await findChatUseCase(
        staff_id: 0,
        customer_id: event.customerId,
        order_id: event.orderId ?? 0,
      );

      emit(FindChatSuccess(room));
    } catch (e) {
      emit(FindChatError(_errorText(e)));
    }
  }

  Future<void> _findAsCustomer(
      FindChatCustomerE event,
      Emitter<FindChatState> emit,
      ) async {
    emit(const FindChatLoading());

    try {
      final room = await findChatUseCase(
        staff_id: event.staffId,
        customer_id: 0,
        order_id: event.orderId ?? 0,
      );

      emit(FindChatSuccess(room));
    } catch (e) {
      emit(FindChatError(_errorText(e)));
    }
  }

  String _errorText(Object e) {
    final t = e.toString().toLowerCase();

    if (t.contains('404') || t.contains('not found')) {
      return "Chat topilmadi (room yo‘q yoki id noto‘g‘ri).";
    }
    if (t.contains('401')) {
      return "Token yaroqsiz (401). Qayta login qiling.";
    }
    if (t.contains('403')) {
      return "Ruxsat yo‘q (403). Token role mos emas.";
    }
    return "Xatolik: $e";
  }
}