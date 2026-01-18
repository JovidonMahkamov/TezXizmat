import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tez_xizmat/bloc_provider.dart';
import 'package:tez_xizmat/core/di/services_locator.dart';
import 'my_app.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox("authBox");
  await setup();
  runApp(MyBlocProvider(child: MyApp(box: box)));
}
