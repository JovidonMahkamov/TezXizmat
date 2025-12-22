import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileWidget extends StatefulWidget {
  final String text;
  final IconData icon;
  final IconData? icon1;
  final VoidCallback onTab;
  final TextStyle textStyle;
  final Color? iconColor;


  const EditProfileWidget(
      {super.key, required this.text, required this.icon, this.icon1, required this.onTab, required this.textStyle, this.iconColor,});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onTab,
            child: Container(
              height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(widget.icon,color: widget.iconColor,),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        widget.text,
                        style: widget.textStyle,
                      ),
                    ],
                  ),
                  // Text(widget.language,style: TextStyle(fontSize: 18.sp),),
                  SizedBox(width: 25.w,),
                  Icon(widget.icon1),
                ],
              ),
            ),
          ),
          SizedBox(child: Divider(),)
        ],
      ),
    );
  }
}
