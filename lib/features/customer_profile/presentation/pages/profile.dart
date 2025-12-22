import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/widgets/edit_profile_widget.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/widgets/image_picker_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          "Profil",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Center(child: ImagePickerWidget()),
          SizedBox(height: 10.h),
          Text(
            "Sevinch Sharobidinova",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
          ),
          SizedBox(height: 40.h),
          EditProfileWidget(
            text: "Profilni tahrirlash",
            icon: Icons.person_outline,
            onTab: () {},
            icon1: Icons.arrow_forward_ios_outlined, textStyle: TextStyle(fontSize: 18.sp),
          ),
          EditProfileWidget(
            text: "Tizimda chiqish",
            icon: Icons.exit_to_app_outlined,iconColor: Colors.red,
            onTab: () {}, textStyle: TextStyle(color: Colors.red,fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
