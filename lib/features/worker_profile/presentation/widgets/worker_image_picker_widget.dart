import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class WorkerImagePickerWidget extends StatefulWidget {
  const WorkerImagePickerWidget({
    super.key,
    required this.uploadImage, // <-- tashqaridan beramiz
    required this.baseUrl,     // <-- "https://tezxizmatlar.uz"
    this.initialImagePath,     // <-- "/media/staff/....png" bo‘lsa
  });

  final Future<String> Function(String filePath) uploadImage;
  final String baseUrl;
  final String? initialImagePath;

  @override
  State<WorkerImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<WorkerImagePickerWidget> {
  File? _imageFile;
  String? _serverImagePath; // "/media/..."
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _serverImagePath = widget.initialImagePath;
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path); // darrov preview
      _loading = true;
    });

    try {
      // serverga yuboramiz (usecase/repo orqali)
      final pathFromServer = await widget.uploadImage(pickedFile.path);

      setState(() {
        _serverImagePath = pathFromServer; // "/media/..."
      });
    } catch (e) {
      // xato bo‘lsa snack chiqsin
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Rasm yuklashda xato: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverUrl = (_serverImagePath != null && _serverImagePath!.isNotEmpty)
        ? "${widget.baseUrl}${_serverImagePath!}"
        : null;

    ImageProvider avatarProvider;

    if (_imageFile != null) {
      avatarProvider = FileImage(_imageFile!); // lokal preview
    } else if (serverUrl != null) {
      avatarProvider = NetworkImage(serverUrl); // serverdagi rasm
    } else {
      avatarProvider = const AssetImage('assets/profile/per.png');
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: avatarProvider,
          child: _loading
              ? const CircularProgressIndicator()
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _loading ? null : _pickAndUploadImage,
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
