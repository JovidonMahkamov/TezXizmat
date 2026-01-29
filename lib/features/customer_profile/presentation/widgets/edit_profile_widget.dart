import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final IconData? icon1;
  final VoidCallback onTab;
  final TextStyle textStyle;
  final Color? iconColor;

  const EditProfileWidget({
    super.key,
    required this.text,
    required this.icon,
    this.icon1,
    required this.onTab,
    required this.textStyle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTab,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: iconColor),
                        SizedBox(width: 20.w),
                        Text(text, style: textStyle),
                      ],
                    ),
                    if (icon1 != null) Icon(icon1),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(child: Divider(),)
        ],
      ),
    );
  }
}
