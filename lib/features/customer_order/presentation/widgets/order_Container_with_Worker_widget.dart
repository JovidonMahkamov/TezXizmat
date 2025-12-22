import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewContainerWorkerWidget extends StatefulWidget {
  final ImageProvider circularImage;
  final String time;
  final String nameText;
  final String experienceText;
  final VoidCallback? onTap;

  const ViewContainerWorkerWidget({
    super.key,
    required this.circularImage,
    required this.nameText,
    required this.experienceText,
    this.onTap, required this.time,
  });

  @override
  State<ViewContainerWorkerWidget> createState() => _HomeContainerWidgetState();
}

class _HomeContainerWidgetState extends State<ViewContainerWorkerWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xffCCCCCC), width: 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: widget.circularImage,
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
                    widget.experienceText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6,),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(widget.time, style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
