import 'dart:async';
import 'dart:convert';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/customer_chat/data/datasource/chat_remote_data_source.dart';
import 'package:tez_xizmat/features/customer_chat/data/datasource/chat_socket_data_source.dart';
import 'package:tez_xizmat/features/customer_chat/data/model/chat_message_model.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_room_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';


class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  final ChatSocketDataSource socket;
  final AuthLocalDataSource local;

  ChatRepositoryImpl({
    required this.remote,
    required this.socket,
    required this.local,
  });

  final _messageController = StreamController<ChatMessageEntity>.broadcast();

  @override
  Future<List<ChatRoomEntity>> getRooms() => remote.getRooms();

  @override
  Future<List<ChatMessageEntity>> getRoomMessages({required int roomId}) =>
      remote.getRoomMessages(roomId: roomId);

  @override
  Future<ChatMessageEntity> sendMessageRest({
    required int roomId,
    required String text,
  }) =>
      remote.sendMessage(roomId: roomId, text: text);

  @override
  Future<void> connectSocket({
    required int roomId,
    required String accessToken,
  }) async {
    await socket.connect(roomId: roomId, token: accessToken);

    // WS streamni domain streamga convert qilamiz
    socket.rawStream().listen((raw) {
      try {
        final decoded = jsonDecode(raw);

        Map<String, dynamic>? payload;

        if (decoded is Map<String, dynamic>) {
          final inner = decoded['data'] ?? decoded['message'] ?? decoded;
          if (inner is Map<String, dynamic>) payload = inner;
        }

        if (payload == null) return;

        final msg = ChatMessageModel.fromJson(payload);
        _messageController.add(msg);
      } catch (_) {
        // xohlasang debugPrint(raw) qilib ko‘rib olasan
      }
    });
  }

  @override
  Future<void> disconnectSocket() => socket.disconnect();

  @override
  Stream<ChatMessageEntity> socketMessages() => _messageController.stream;

  @override
  Future<void> sendMessageSocket({required String text}) async {
    // Backendchi misolida: {"text":"..."} yuboriladi
    final payload = jsonEncode({"text": text});
    await socket.sendRaw(payload);
  }
}
