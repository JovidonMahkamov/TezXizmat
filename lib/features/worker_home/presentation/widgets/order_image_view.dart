import 'package:flutter/material.dart';

class OrderImageView extends StatelessWidget {
  final String heroTag;
  final ImageProvider image;

  const OrderImageView({
    super.key,
    required this.heroTag,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Hero(
              tag: heroTag,
              child: CircleAvatar(
                radius: 140,
                backgroundColor: Colors.grey.shade800,
                backgroundImage: image,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
