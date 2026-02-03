import 'package:tez_xizmat/core/network/chat_api_urls.dart';
import 'package:tez_xizmat/core/network/customer_api_urls.dart';
import 'package:tez_xizmat/features/customer_chat/data/datasource/chat_socket_data_source.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  final String baseUrl;
  WebSocketChannel? _channel;

  final _controller = StreamController<String>.broadcast();

  ChatSocketDataSourceImpl({String? baseUrl})
      : baseUrl = baseUrl ?? CustomerApiUrls.baseUrl;

  @override
  Future<void> connect({required int roomId, required String token}) async {
    print(" token(raw)='${token}'");
    print(" token(trim)='${token.trim()}'");
    print(" token endsWith# = ${token.trim().endsWith('#')}");

    final wsUrl = ChatApiUrls.wsChat(
      baseUrl: baseUrl,
      roomId: roomId,
      token: token,
    );

    final wsUri = Uri.parse(wsUrl).replace(fragment: '');
    print("✅ WS URI = $wsUri");

    try {
      _channel = IOWebSocketChannel.connect(
        wsUri,
        pingInterval: const Duration(seconds: 10),
      );
    } catch (e) {
      print("❌ WS CONNECT THROW: $e");
      // xohlasang shu yerda custom exception qil
      rethrow;
    }

    _channel!.stream.listen(
          (event) {
        if (event is String) _controller.add(event);
      },
      onError: (e) {
        print("❌ WS ERROR: $e");
        _controller.addError(e);
      },
      onDone: () {
        print("! WS CLOSED");
      },
      cancelOnError: false,
    );
  }

  @override
  Stream<String> rawStream() => _controller.stream;

  @override
  Future<void> sendRaw(String data) async {
    final ch = _channel;
    if (ch == null) throw StateError('Socket ulanmagan');
    ch.sink.add(data);
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }
}