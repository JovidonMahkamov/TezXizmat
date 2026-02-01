import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:tez_xizmat/core/network/chat_api_urls.dart';
import 'chat_socket_data_source.dart';

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  WebSocketChannel? _channel;
  final _controller = StreamController<String>.broadcast();

  @override
  Future<void> connect({required int roomId, required String token}) async {
    await disconnect();

    final url = ChatApiUrls.wsConnect(roomId: roomId, token: token);
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
          (event) => _controller.add(event.toString()),
      onError: (e, st) => _controller.addError(e, st),
      onDone: () {
        _controller.addError(StateError('WebSocket closed'));
      },
    );
  }


  @override
  Future<void> disconnect() async {
    try {
      await _channel?.sink.close(status.goingAway);
    } catch (_) {}
    _channel = null;
  }

  @override
  Stream<String> rawStream() => _controller.stream;

  @override
  Future<void> sendRaw(String data) async {
    final ch = _channel;
    if (ch == null) {
      throw StateError('WebSocket not connected');
    }
    ch.sink.add(data);
  }

}
