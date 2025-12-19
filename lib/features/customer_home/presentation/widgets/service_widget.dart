import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget serviceWidget({ required String text}) {
  return Row(
    children: [
      Icon(Icons.check),
      SizedBox(width: 6.w),
      Text(
        text,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500,color: Color(0xff4D4D4D)),
      ),
    ],
  );
}
