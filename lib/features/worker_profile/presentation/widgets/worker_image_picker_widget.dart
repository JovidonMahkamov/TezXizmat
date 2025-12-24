import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class WorkerImagePickerWidget extends StatefulWidget {
  const WorkerImagePickerWidget({super.key});

  @override
  State<WorkerImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<WorkerImagePickerWidget> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : const AssetImage('assets/circular_avatar/profile.png')
          as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
                padding: EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.blue,
                ),
                child:   SvgPicture.asset("assets/profile/edit.svg")),
          ),

        ),
      ],
    );
  }
}
