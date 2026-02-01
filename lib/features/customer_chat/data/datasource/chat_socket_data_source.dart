import 'dart:async';

abstract class ChatSocketDataSource {
  Future<void> connect({required int roomId, required String token});
  Future<void> disconnect();

  Stream<String> rawStream();

  Future<void> sendRaw(String data);
}
