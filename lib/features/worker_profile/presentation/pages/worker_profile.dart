import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/widgets/edit_profile_widget.dart';
import '../../../customer_home/presentation/widgets/rating_info_widget.dart';
import '../widgets/worker_image_picker_widget.dart';
import '../widgets/worker_log_out_widget.dart';

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerInfoPageState();
}

class _WorkerInfoPageState extends State<WorkerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "Profil",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Center(child: WorkerImagePickerWidget()),
          SizedBox(height: 10.h),
          Text(
            "Sevinch Sharobidinova",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
          ),
          Text(
            "jovidon@gmail.com",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SizedBox(child: Divider()),
          ),
          EditProfileWidget(
            text: "Profilni tahrirlash",
            icon: Icons.person_outline,
            onTab: () {
              Navigator.pushNamed(context, RouteNames.workerEditProfile);
            },
            icon1: Icons.arrow_forward_ios_outlined,
            textStyle: TextStyle(fontSize: 18.sp),
          ),
          EditProfileWidget(
            text: "Reyting va sharhlar",
            icon: Icons.star_border_outlined,
            onTab: () {
              showRatingSheet(context);
            },
            icon1: Icons.arrow_forward_ios_outlined,
            textStyle: TextStyle(fontSize: 18.sp),
          ),
          EditProfileWidget(
            text: "Tizimda chiqish",
            icon: Icons.exit_to_app_outlined,
            iconColor: Colors.red,
            onTab: () {
              workerLogOutProfileQuestion(context);
            },
            textStyle: TextStyle(color: Colors.red, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
  String name = "Sevinch";
  String surname = "Sharobidinova";
  String email = "jovidon@gmail.com";

  void showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: name);
    final surnameController = TextEditingController(text: surname);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w), // chetlar
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: double.infinity, // 🔥 BUTUN WIDTH
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profilni tahrirlash",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_outlined),
                      ),
                    ],
                  ),

                  Text('Ism', style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                  SizedBox(height: 2.h),
                  TextFieldWidget(
                    text: "",
                    obscureText: false,
                    controller: nameController,
                  ),

                  SizedBox(height: 16.h),
                  Text('Familiya', style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                  SizedBox(height: 2.h),
                  TextFieldWidget(
                    text: "",
                    obscureText: false,
                    controller: surnameController,
                  ),

                  SizedBox(height: 24.h),

                  ElevatedWidget(
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          surnameController.text.isEmpty) {
                        return;
                      }

                      setState(() {
                        name = nameController.text;
                        surname = surnameController.text;
                      });

                      Navigator.pop(context);
                    },
                    text: "Saqlash",
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }
}








