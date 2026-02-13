import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/widgets/edit_profile_widget.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/my_reviews/my_reviews_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/pages/rating_sheet_body_two.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/widgets/worker_log_out_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerProfileSettingsPage extends StatefulWidget {
  const WorkerProfileSettingsPage({super.key});

  @override
  State<WorkerProfileSettingsPage> createState() =>
      _WorkerProfileSettingsPageState();
}

class _WorkerProfileSettingsPageState extends State<WorkerProfileSettingsPage> {
  final Uri support = Uri.parse('https://t.me/MrJovidon');

  Future<void> _support() async {
    if (!await launchUrl(support, mode: LaunchMode.externalApplication)) {
      throw 'Telegram ochilmadi: $support';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "Sozlamalar",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SizedBox(child: Divider()),
          ),
          EditProfileWidget(
            text: "Profilni tahrirlash",
            icon: Icons.person_outline,
            onTab: () async {
              final result = await Navigator.pushNamed(
                context,
                RouteNames.workerEditProfile,
              );
              if (result != null) {
                context.read<WorkerProfileBloc>().add(WorkerProfileE());
              }
            },

            icon1: Icons.arrow_forward_ios_outlined,
            textStyle: TextStyle(fontSize: 18.sp),
          ),
          EditProfileWidget(
            text: "Reyting va sharhlar",
            icon: Icons.star_border_outlined,
            onTab: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  return BlocProvider.value(
                    value: context.read<MyReviewsBloc>()..add(MyReviewsE()),
                    child: const RatingSheetBodyTwo(),
                  );
                },
              );
            },
            icon1: Icons.arrow_forward_ios_outlined,
            textStyle: TextStyle(fontSize: 18.sp),
          ),

          EditProfileWidget(
            text: "Biz bilan bog'lanish",
            icon: Icons.support_agent_outlined,
            onTab: _support,
            icon1: Icons.arrow_forward_ios_outlined,
            textStyle: TextStyle(fontSize: 18.sp),
          ),

          EditProfileWidget(
            text: "Tizimda chiqish",
            icon: Icons.exit_to_app_outlined,
            iconColor: Colors.red,
            onTab: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const WorkerLogOutWidget(),
              );
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
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: double.infinity,
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_outlined),
                      ),
                    ],
                  ),

                  Text(
                    'Ism',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 2.h),
                  TextFieldWidget(
                    text: "",
                    obscureText: false,
                    controller: nameController,
                    readOnly: false,
                  ),

                  SizedBox(height: 16.h),
                  Text(
                    'Familiya',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 2.h),
                  TextFieldWidget(
                    text: "",
                    obscureText: false,
                    controller: surnameController,
                    readOnly: false,
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
