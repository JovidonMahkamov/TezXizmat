import 'package:flutter/material.dart';

const String profileHeroTag = "worker-profile-image";

class WorkerProfileImageView extends StatelessWidget {
  final String imageUrl;

  const WorkerProfileImageView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 🔙 bo‘sh joy bosilganda home’ga qaytadi
          Navigator.pop(context);
        },
        child: Center(
          child: GestureDetector(
            // ❗ avatar bosilsa pop bo‘lmasin
            onTap: () {},
            child: Hero(
              tag: profileHeroTag,
              child: CircleAvatar(
                radius: 140, // katta circular avatar
                backgroundColor: Colors.grey.shade800,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
