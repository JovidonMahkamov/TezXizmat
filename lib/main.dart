import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tez_xizmat/bloc_provider.dart';
import 'package:tez_xizmat/core/di/services_locator.dart';
import 'core/notification/notification_service.dart';
import 'my_app.dart';

///  Background/Terminated holatda keladigan FCM uchun handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // background isolate ichida ham Firebase init bo'lishi shart
  await Firebase.initializeApp();
  debugPrint(' BG message: ${message.messageId}, data=${message.data}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Hive
  await Hive.initFlutter();
  final box = await Hive.openBox("authBox");

  //  DI
  await setup();

  //  Firebase
  await Firebase.initializeApp();

  //  Background handler ro'yxatdan o'tkazish (Firebase initdan keyin)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  //  Local notifications init (channel + initialize)
  await NotificationService.instance.initLocal();

  //  FCM init (permission + token + listeners)
  await NotificationService.instance.initFCM();

  //  Notification bosilganda qayerga o'tishni shu yerda berasan
  // Route nomlarini sening project route'lariga moslab o'zgartirasan.
  NotificationService.instance.onTap = (data) {
    final type = data['type'];

    if (type == 'new_order') {
      final orderId = data['order_id'];

      // 1) Agar MyApp ichida navigatorKey ishlatsang, shu yerda push qilasan.
      // 2) Yoki oddiy qilib hozircha faqat log qoldiramiz (xato chiqmasin).
      debugPrint(' Open order detail. orderId=$orderId');
    }
  };

  runApp(MyBlocProvider(child: MyApp(box: box)));
}