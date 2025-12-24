import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';

class HomeWorkerAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const
  HomeWorkerAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<HomeWorkerAppBarWidget> createState() => _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends State<HomeWorkerAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/home/profile_image.png"),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              "Hello👋 Franklin",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(onPressed:(){
          Navigator.pushNamed(context, RouteNames.notification);
        }, icon: SvgPicture.asset("assets/home/notification.svg")),
        SizedBox(width: 15.w),
      ],
    );
  }
}
