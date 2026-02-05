import 'package:dio/dio.dart';
import 'package:tez_xizmat/core/network/chat_api_urls.dart';
import 'package:tez_xizmat/core/network/customer_api_urls.dart';
import 'package:tez_xizmat/core/network/customer_dio_client.dart';
import 'package:tez_xizmat/core/network/staff_api_urls.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_delete_model.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_message_model.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_room_model.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/find_chat_model.dart';
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
      return data
          .map((e) => ChatRoomModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // Ba'zi backendlar {"results":[...]} qaytarishi mumkin
    if (data is Map && data['results'] is List) {
      final list = data['results'] as List;
      return list
          .map((e) => ChatRoomModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }

  @override
  Future<List<ChatMessageModel>> getRoomMessages({required int roomId}) async {
    final resp = await _client.get(ChatApiUrls.roomMessages(roomId));
    final data = resp.data;

    if (data is List) {
      return data
          .map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (data is Map && data['results'] is List) {
      final list = data['results'] as List;
      return list
          .map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required int roomId,
    required String text,
  }) async {
    final resp = await _client.post(
      ChatApiUrls.sendToRoom(roomId),
      data: {"text": text},
    );

    return ChatMessageModel.fromJson(Map<String, dynamic>.from(resp.data));
  }

  @override
  Future<FindChatModel> findChat({
    required int staff_id,
    required int customer_id,
    required int order_id,
  }) async{
    if (staff_id == 0 && customer_id == 0) {
      throw Exception("staff_id yoki customer_id dan bittasi 0 bo'lmasin!");
    }
    try {

      final response = await customerClient.post(
        CustomerApiUrls.findChat,
        data: {"staff_id":staff_id,"customer_id":customer_id,"order_id":order_id},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info(" findRoom success: ${response.data}");
        return FindChatModel.fromJson(response.data as Map<String, dynamic>);
      }

      LoggerService.warning("❌ findRoom failed: ${response.statusCode}");
      throw Exception("findRoom failed: ${response.statusCode}");
    } on DioException catch (e, s) {
      LoggerService.error("❌ DioException findRoom: ${e.message}");
      LoggerService.error("❌ response: ${e.response?.data}");
      // print(s); // kerak bo‘lsa
      rethrow;
    } catch (e, s) {
      LoggerService.error("❌ Unknown error findRoom: $e");
      // print(s);
      rethrow;
    }
  }

  @override
  Future<ChatDeleteModel> deleteChat({required int roomId})async {
    try {
      final response = await customerClient.delete('${CustomerApiUrls.deleteChat}$roomId/delete/');

      // Swagger: 204 Deleted (body yo'q)
      if (response.statusCode == 204) {
        return const ChatDeleteModel();
      }

      // Ba'zi backendlar 200 ham qaytarishi mumkin (xavfsiz)
      if (response.statusCode == 200) {
        return const ChatDeleteModel();
      }

      throw Exception('Delete chat failed. Status: ${response.statusCode}');
    } on DioException catch (e) {
      // xohlasa: e.response?.statusCode, e.response?.data
      throw Exception(e.response?.data?.toString() ?? e.message);
    }
  }
}


