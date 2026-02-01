import 'package:tez_xizmat/core/network/chat_api_urls.dart';
import 'package:tez_xizmat/core/network/customer_dio_client.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_message_model.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_room_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final CustomerDioClient customerClient;
  final StaffDioClient staffClient;
  final AuthLocalDataSource local;

  ChatRemoteDataSourceImpl({
    required this.customerClient,
    required this.staffClient,
    required this.local,
  });

  bool get _isStaff => (local.getRole() ?? 'customer') == 'staff';

  dynamic get _client => _isStaff ? staffClient : customerClient;

  @override
  Future<List<ChatRoomModel>> getRooms() async {
    final resp = await _client.get(ChatApiUrls.rooms);
    final data = resp.data;

    if (data is List) {
      return data.map((e) => ChatRoomModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    // Ba'zi backendlar {"results":[...]} qaytarishi mumkin
    if (data is Map && data['results'] is List) {
      final list = data['results'] as List;
      return list.map((e) => ChatRoomModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    return [];
  }

  @override
  Future<List<ChatMessageModel>> getRoomMessages({required int roomId}) async {
    final resp = await _client.get(ChatApiUrls.roomMessages(roomId));
    final data = resp.data;

    if (data is List) {
      return data.map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    if (data is Map && data['results'] is List) {
      final list = data['results'] as List;
      return list.map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    return [];
  }

  @override
  Future<ChatMessageModel> sendMessage({required int roomId, required String text}) async {
    final resp = await _client.post(
      ChatApiUrls.sendToRoom(roomId),
      data: {"text": text},
    );

    return ChatMessageModel.fromJson(Map<String, dynamic>.from(resp.data));
  }
}
