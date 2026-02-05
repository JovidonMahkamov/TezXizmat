import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
    this.radius = 60,
    this.placeholderAsset = 'assets/circular_avatar/profile.png',
    this.onPicked, // agar xohlasangiz tanlangan file qaytarib beradi
  });

  final double radius;
  final String placeholderAsset;
  final ValueChanged<File>? onPicked;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  bool _loading = false;

  Future<bool> _ensureGalleryPermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      // Android 13+ da READ_MEDIA_IMAGES -> permission_handler: Permission.photos
      status = await Permission.photos.request();

      // Ba'zi device/romlarda photos ishlamasa fallback:
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
    } else {
      // iOS
      status = await Permission.photos.request();
    }

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Rasm tanlash uchun ruxsat kerak. Settings'dan yoqing."),
        ),
      );
      await openAppSettings();
      return false;
    }

    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rasm tanlash uchun ruxsat bering.")),
    );
    return false;
  }

  Future<void> _pickImage() async {
    if (_loading) return;

    final ok = await _ensureGalleryPermission();
    if (!ok) return;

    setState(() => _loading = true);

    try {
      final XFile? picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) {
        // user bekor qildi
        if (!mounted) return;
        setState(() => _loading = false);
        return;
      }

      final file = File(picked.path);
      final exists = await file.exists();
      if (!exists) throw Exception("Tanlangan rasm topilmadi: ${picked.path}");

      if (!mounted) return;
      setState(() {
        _imageFile = file;
        _loading = false;
      });

      widget.onPicked?.call(file);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Rasm tanlashda xatolik: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider avatarProvider = (_imageFile != null)
        ? FileImage(_imageFile!)
        : AssetImage(widget.placeholderAsset);

    return Stack(
      children: [
        CircleAvatar(
          radius: widget.radius,
          backgroundImage: avatarProvider,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset("assets/profile/edit.svg"),
            ),
          ),
        ),
      ],
    );
  }
}
