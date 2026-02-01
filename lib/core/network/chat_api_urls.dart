abstract class ChatApiUrls {
  static const String baseUrl = 'https://tezxizmatlar.uz';

  // REST
  static const String rooms = '/api/chat/rooms/';
  static String roomMessages(int roomId) => '/api/chat/rooms/$roomId/messages/';
  static String sendToRoom(int roomId) => '/api/chat/rooms/$roomId/send/';

  // WS
  static String wsConnect({
    required int roomId,
    required String token,
  }) =>
      'wss://tezxizmatlar.uz/ws/chat/$roomId/?token=$token';
}
