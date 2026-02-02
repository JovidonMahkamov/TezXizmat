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

    // ✅ MUHIM: ws/wss uchun default portni qo'lda beramiz
    final port = http.hasPort
        ? http.port
        : (wsScheme == 'wss' ? 443 : 80);

    final safeToken = token.trim().replaceAll('#', ''); // ehtiyot uchun

    final uri = Uri(
      scheme: wsScheme,
      host: http.host,
      port: port,
      path: '/ws/chat/$roomId/',
      queryParameters: {'token': safeToken},
    );

    return uri.toString();
  }
}
