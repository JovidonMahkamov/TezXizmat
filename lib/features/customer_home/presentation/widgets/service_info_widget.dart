import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget serviceInfoWidget({required String iconPath, required String text}) {
  return Row(
    children: [
      SvgPicture.asset(iconPath, width: 24, height: 24),
      SizedBox(width: 6.w),
      Text(
        text,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
