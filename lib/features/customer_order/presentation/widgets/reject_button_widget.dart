import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class RejectButtonWidget extends StatelessWidget {
  final double? size;
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Icon? iconImage;
  const RejectButtonWidget({super.key, required this.onPressed,required this.text, this.size, required this.backgroundColor, required this.textColor, this.iconImage});
  @override
  Widget build (BuildContext context) {
    return SizedBox(
      width: size,
      height: 46.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: backgroundColor,
        ),
        onPressed:onPressed,
        child:  Row(
          children: [
            SvgPicture.asset("assets/chat/undov.svg"),
            SizedBox(width: 60.w,),
            Text(
              text,
              style: TextStyle (color: textColor),
            ),
          ],
        ),
      ),
    );
  }

}