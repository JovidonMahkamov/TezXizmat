import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class RejectButtonWidget extends StatelessWidget {
  final double? size;
  final void Function()? onPressed;
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
          disabledBackgroundColor: backgroundColor,
        ),
        onPressed:onPressed,
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/chat/undov.svg",
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(width: 10.w,),
            Text(
              text,
              style: TextStyle (color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

}