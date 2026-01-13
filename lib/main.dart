import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_xizmat/bloc_provider.dart';
import 'package:tez_xizmat/core/di/services_locator.dart';
import 'my_app.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MyBlocProvider(child: MyApp()));
}
