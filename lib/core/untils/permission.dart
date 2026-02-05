import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestGalleryPermission() async {
  if (!Platform.isAndroid) {
    // iOS bo'lsa:
    final st = await Permission.photos.request();
    return st.isGranted || st.isLimited;
  }

  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final sdk = androidInfo.version.sdkInt;

  // Android 13+ (API 33+): Photos permission
  if (sdk >= 33) {
    final st = await Permission.photos.request();
    return st.isGranted || st.isLimited;
  }

  // Android 12 va past: Storage permission
  final st = await Permission.storage.request();
  return st.isGranted;
}
