import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeContainerWidget extends StatefulWidget {
  final ImageProvider circularImage;
  final String nameText;
  final String profession;
  final VoidCallback? onTap;
  final String heroTag;
  final VoidCallback? onImageTap;

  const HomeContainerWidget({
    super.key,
    required this.circularImage,
    required this.nameText,
    required this.profession,
    this.onTap,
    required this.heroTag,
    this.onImageTap,

  });

  @override
  State<HomeContainerWidget> createState() => _HomeContainerWidgetState();
}

class _HomeContainerWidgetState extends State<HomeContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 85.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Row(
          children: [
          GestureDetector(
          onTap: widget.onImageTap,
          child: Hero(
            tag: widget.heroTag,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: widget.circularImage,
            ),
          ),
        ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nameText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    widget.profession,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_outlined),
          ],
        ),
      ),
    );
  }
}
