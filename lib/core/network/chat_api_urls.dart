class ChatApiUrls {
  static const String rooms = '/api/chat/rooms/';
  static String roomMessages(int roomId) => '/api/chat/rooms/$roomId/messages/';
  static String sendToRoom(int roomId) => '/api/chat/rooms/$roomId/messages/';

  static String wsChat({
    required String baseUrl,
    required int roomId,
    required String token,
  }) {
    final http = Uri.parse(baseUrl);
    final wsScheme = (http.scheme == 'https') ? 'wss' : 'ws';

    final safeToken = token.trim().replaceAll('#', '');

    // default port bo'lsa UMUMAN yozmaymiz
    final usePort = http.hasPort && http.port != 80 && http.port != 443;

    final uri = Uri(
      scheme: wsScheme,
      host: http.host,
      port: usePort ? http.port : null,
      path: '/ws/chat/$roomId/',
      queryParameters: {'token': safeToken},
    );

    return uri.toString();
  }

}