import 'package:tez_xizmat/features/customer_chat/data/model/chat_message_model.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_room_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatRoomModel>> getRooms();
  Future<List<ChatMessageModel>> getRoomMessages({required int roomId});
  Future<ChatMessageModel> sendMessage({required int roomId, required String text});
}
