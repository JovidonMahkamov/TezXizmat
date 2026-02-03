import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class WorkerImagePickerWidget extends StatefulWidget {
  const WorkerImagePickerWidget({
    super.key,
    required this.uploadImage, // filePath -> server path qaytaradi, masalan "/media/staff/33.jpg"
    required this.baseUrl,     // "https://tezxizmatlar.uz"
    this.initialImagePath,
  });

  final Future<String> Function(String filePath) uploadImage;
  final String baseUrl;
  final String? initialImagePath;

  @override
  State<WorkerImagePickerWidget> createState() => _WorkerImagePickerWidgetState();
}

class _WorkerImagePickerWidgetState extends State<WorkerImagePickerWidget> {
  File? _imageFile;
  String? _serverImagePath;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _serverImagePath = widget.initialImagePath;
  }

  Future<bool> _ensureGalleryPermission() async {
    // Android 9 uchun: storage permission
    // Android 13+ bo‘lsa: photos. Lekin siz Android 9 ekansiz.
    final status = await Permission.storage.request();

    if (status.isGranted) return true;

    // user butunlay rad qilgan bo‘lsa
    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rasm tanlash uchun ruxsat kerak. Settings'dan yoqing.")),
      );
      await openAppSettings();
      return false;
    }

    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rasm tanlash uchun storage ruxsatini bering.")),
    );
    return false;
  }

  void _showError(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: Colors.red),
    );
  }

  Future<void> _pickAndUploadImage() async {
    if (_loading) return;

    final ok = await _ensureGalleryPermission();
    if (!ok) return;

    setState(() => _loading = true);

    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        // user bekor qildi
        setState(() => _loading = false);
        return;
      }

      // Android ba’zida path bo‘sh qaytarishi mumkin
      final path = image.path;
      if (path.isEmpty) {
        throw Exception("Image path bo‘sh qaytdi (Android picker muammo).");
      }

      final file = File(path);
      final exists = await file.exists();
      if (!exists) {
        throw Exception("Selected image not found: $path");
      }

      // Lokal preview
      setState(() => _imageFile = file);

      // Upload (serverdan yangi path qaytadi deb hisoblaymiz)
      final newServerPath = await widget.uploadImage(path);

      if (!mounted) return;
      setState(() {
        _serverImagePath = newServerPath; // "/media/..."
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showError("Rasm tanlashda xatolik: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverUrl = (_serverImagePath != null && _serverImagePath!.isNotEmpty)
        ? "${widget.baseUrl}${_serverImagePath!}"
        : null;

    final ImageProvider avatarProvider;
    if (_imageFile != null) {
      avatarProvider = FileImage(_imageFile!);
    } else if (serverUrl != null) {
      avatarProvider = NetworkImage(serverUrl);
    } else {
      avatarProvider = const AssetImage('assets/profile/per.png');
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: avatarProvider,
          child: _loading ? const CircularProgressIndicator() : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickAndUploadImage,
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset("assets/profile/edit.svg"),
            ),
          ),
        ),
      ],
    );
  }
}
