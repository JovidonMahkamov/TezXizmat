import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/get_chat_rooms_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';
import '../../../domain/entities/chat_room_entity.dart';
import 'chat_rooms_state.dart';

class ChatRoomsBloc extends Bloc<ChatEvent, ChatRoomsState> {
  final GetChatRoomsUseCase getRooms;

  ChatRoomsBloc({required this.getRooms}) : super(const ChatRoomsInitial()) {
    on<GetChatRoomsE>(_onGetRooms);
  }

  Future<void> _onGetRooms(GetChatRoomsE event, Emitter<ChatRoomsState> emit) async {
    if (!event.silent) {
      emit(const ChatRoomsLoading());
    }

    try {
      final rooms = await getRooms();
      final list = List<ChatRoomEntity>.from(rooms);

      emit(ChatRoomsSuccess(list));
    } catch (e) {
      emit(ChatRoomsError(e.toString()));
    }
  }
}
