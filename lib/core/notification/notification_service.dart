import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  /// Notification bosilganda (foreground local notif yoki fcm) data bilan ishlash
  void Function(Map<String, dynamic> data)? onTap;

  /// Local notifications init (Android channel, initialize)
  Future<void> initLocal() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS ishlatmasang ham bo'ladi, lekin qo'shib qo'yamiz (xavfsiz)
    const darwinInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
    );

    // ✅ v20: settings: named parameter
    await _local.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;

        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          onTap?.call(data);
        } catch (e) {
          debugPrint('❌ payload jsonDecode error: $e');
        }
      },
      // background callback iOS uchun ham bo'lishi mumkin, hozir shart emas
      // onDidReceiveBackgroundNotificationResponse: ...
    );

    // ✅ Android channel yaratish (Android 8+)
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications.',
      importance: Importance.max,
    );

    final androidPlugin =
    _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    // ✅ Android 13+ uchun local notification permission (ba'zi holatlarda kerak bo'ladi)
    await androidPlugin?.requestNotificationsPermission();
  }

  /// Firebase Messaging init (permission, token, listeners)
  Future<void> initFCM() async {
    final fcm = FirebaseMessaging.instance;

    // ✅ iOS + Android 13+ permission
    final settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔔 FCM Permission: ${settings.authorizationStatus}');

    // ✅ Token olish
    final token = await fcm.getToken();
    debugPrint('✅ FCM TOKEN: $token');

    // ✅ Token refresh
    fcm.onTokenRefresh.listen((newToken) {
      debugPrint('♻️ FCM TOKEN REFRESH: $newToken');
      // TODO: backend bo'lsa tokenni serverga yuborasiz
    });

    // ✅ Foreground: FCM kelganda sistem notif ko'rsatmaydi, shuning uchun local notif chiqaramiz
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showFromFCM(message);
    });

    // ✅ Backgrounddan notif bosib ochilganda
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onTap?.call(_safeMap(message.data));
    });

    // ✅ Terminated (app yopiq) bo'lib notif bosib ochilganda
    final initial = await fcm.getInitialMessage();
    if (initial != null) {
      onTap?.call(_safeMap(initial.data));
    }
  }

  /// FCM message'dan local notification ko'rsatish (foreground uchun)
  Future<void> showFromFCM(RemoteMessage message) async {
    final title = message.notification?.title ?? 'Tez Xizmat';
    final body = message.notification?.body ?? 'Yangi xabar';

    // message.data Map<dynamic,dynamic> bo'lishi mumkin → String,dynamic qilamiz
    final data = _safeMap(message.data);

    await showLocal(
      title: title,
      body: body,
      data: data,
    );
  }


  /// O'zing istagan joydan local notification chiqarish
  Future<void> showLocal({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    final payload = jsonEncode(data ?? <String, dynamic>{});

    await _local.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  Map<String, dynamic> _safeMap(Map data) {
    // RemoteMessage.data ba'zida Map<String, dynamic>, ba'zida Map<dynamic, dynamic>
    return data.map((key, value) => MapEntry(key.toString(), value));
  }
}

