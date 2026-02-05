import 'package:tez_xizmat/features/customer_chat/data/model/chat_delete_model.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_message_model.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_room_model.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/find_chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatRoomModel>> getRooms();
  Future<List<ChatMessageModel>> getRoomMessages({required int roomId});
  Future<ChatMessageModel> sendMessage({required int roomId, required String text});
  Future<FindChatModel> findChat({required int staff_id, required int customer_id,required int order_id});
  Future<ChatDeleteModel> deleteChat({required int roomId});
}
