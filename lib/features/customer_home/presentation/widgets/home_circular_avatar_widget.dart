import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCircularAvatarWidget extends StatefulWidget {
  final Widget iconAvatar;
  final String title;
  final Color circularColor;
  final void Function()? onTap;

  const HomeCircularAvatarWidget({
    Key? key,
    required this.iconAvatar,
    required this.title,
    required this.circularColor, this.onTap,
  }) : super(key: key);

  @override
  State<HomeCircularAvatarWidget> createState() => _HomeCircularAvatarWidgetState();
}

class _HomeCircularAvatarWidgetState extends State<HomeCircularAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40.r,
              child: Center(child: widget.iconAvatar),
              backgroundColor: widget.circularColor,
            ),
          ),
        ),
        SizedBox(height: 10.w,),
        Text(widget.title,style: TextStyle(fontSize: 12.sp),)
      ],
    );
  }
}
