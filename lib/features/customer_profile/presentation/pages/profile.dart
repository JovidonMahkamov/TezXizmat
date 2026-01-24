import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_event.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_state.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/widgets/edit_profile_widget.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/widgets/image_picker_widget.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/widgets/profile_log_out_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // UI ochilishi bilan API chaqiriladi
    context.read<CustomerProfileBloc>().add(CustomerProfileE());
  }

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

      body: BlocBuilder<CustomerProfileBloc, CustomerProfileState>(
        builder: (context, state) {
          // 1) LOADING
          if (state is CustomerProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) ERROR
          if (state is CustomerProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CustomerProfileBloc>().add(
                          CustomerProfileE(),
                        );
                      },
                      child: const Text("Qayta urinish"),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3) LOADED
          if (state is CustomerProfileSuccess) {
            final profile = state.customerProfileEntity;
            // profile: UserProfileEntity bo‘lishi kerak (firstName,lastName,email)

            return Column(
              children: [
                const Center(child: ImagePickerWidget()),
                SizedBox(height: 10.h),

                Text(
                  "${profile.firstName} ${profile.lastName}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
                ),

                Text(
                  profile.email,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 10.h),
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Divider(),
                ),

                EditProfileWidget(
                  text: "Profilni tahrirlash",
                  icon: Icons.person_outline,
                  onTab: () {
                    // dialogga hozirgi ism/familiyani berib yuboramiz
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => EditProfileDialog(
                        firstName: profile.firstName,
                        lastName: profile.lastName,
                      ),
                    );

                  },
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
                      builder: (_) => const ProfileLogOutWidget(),
                    );
                  },
                  textStyle: TextStyle(color: Colors.red, fontSize: 18.sp),
                ),
              ],
            );
          }

          // Default (agar state initial bo‘lsa)
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Profilni tahrirlash dialogi
  /// Eslatma: bu joy faqat UI. Update API bo‘lsa keyin event qo‘shamiz.
  void showEditProfileDialog(
    BuildContext context, {
    required String firstName,
    required String lastName,
  }) {
    final nameController = TextEditingController(text: firstName);
    final surnameController = TextEditingController(text: lastName);

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

                  // sening TextFieldWidget’ing bo‘lsa shu qoladi:
                  // TextFieldWidget(text:"", obscureText:false, controller:nameController, readOnly:false),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 16.h),
                  Text(
                    'Familiya',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 2.h),
                  // TextFieldWidget(...)
                  TextField(
                    controller: surnameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            surnameController.text.isEmpty)
                          return;

                        // 🔥 Agar update API bo‘lsa shu yerda event jo‘natasan:
                        // context.read<ProfileBloc>().add(UpdateProfileEvent(
                        //   firstName: nameController.text.trim(),
                        //   lastName: surnameController.text.trim(),
                        // ));

                        Navigator.pop(context);
                      },
                      child: const Text("Saqlash"),
                    ),
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
