import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_image/customer_profile_image_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_image/customer_profile_image_state.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_state.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/update_profile_bloc/customer_update_profile_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/update_profile_bloc/customer_update_profile_state.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_event.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/widgets/worker_image_picker_widget.dart';


class EditProfileDialog extends StatefulWidget {
  final String firstName;
  final String lastName;

  const EditProfileDialog({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController nameController;
  late final TextEditingController surnameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.firstName);
    surnameController = TextEditingController(text: widget.lastName);
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerUpdateProfileBloc, CustomerUpdateProfileState>(
      listener: (context, state) {
        // Update success bo‘lsa dialog yopiladi
        if (state is CustomerUpdateProfileSuccess) {
          Navigator.pop(context);
          context.read<CustomerProfileBloc>().add(CustomerProfileE());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profil yangilandi ✅")),
          );
          // Profilni qayta olib kelish (entity ichida yangisi qaytsa ham bo‘ladi)
          context.read<CustomerUpdateProfileBloc>().add(CustomerUpdateProfileE(name: nameController.text.trim(), surname: surnameController.text.trim()));
        }

        // Error bo‘lsa Snackbar
        if (state is CustomerUpdateProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CustomerUpdateProfileLoading;
        // Agar sendeda alohida Updating state bo‘lsa: state is CustomerProfileUpdating

        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
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
                          onPressed: isLoading ? null : () => Navigator.pop(context),
                          icon: const Icon(Icons.close_outlined),
                        ),
                      ],
                    ),
                    Center(
                      child: BlocConsumer<CustomerProfileImageBloc, CustomerProfileImageState>(
                        listener: (context, imgState) {
                          if (imgState is CustomerProfileImageError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(imgState.message)),
                            );
                          }
                        },
                        builder: (context, imgState) {
                          // image pathni bloc state’dan olamiz
                          final profileState = context.watch<CustomerProfileBloc>().state;
                          String? imagePath;
            
                          if (profileState is CustomerProfileSuccess) {
                            imagePath = profileState.customerProfileEntity.image;
                          }
            
            
                          return WorkerImagePickerWidget(
                            baseUrl: "https://tezxizmatlar.uz",
                            initialImagePath: imagePath, // <-- endi state.profile.image emas
                            uploadImage: (filePath) async {
                              // Widget Future<String> kutyapti, shuning uchun bloc’dan natijani kutib qaytaramiz
                              final bloc = context.read<CustomerProfileImageBloc>();
            
                              final completer = Completer<String>();
                              late final StreamSubscription sub;
            
                              sub = bloc.stream.listen((s) {
                                if (s is CustomerProfileImageSuccess) {
                                  context.read<CustomerProfileBloc>().add(CustomerProfileE());
            
                                  completer.complete(s.customerProfileImageEntity.image);
                                  sub.cancel();
                                } else if (s is CustomerProfileImageError) {
                                  completer.completeError(s.message);
                                  sub.cancel();
                                }
                              });
            
                              bloc.add(CustomerProfileImageE(filePath: filePath));
            
                              return completer.future;
                            },
                          );
                        },
                      ),
                    ),
                    Text("Ism", style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                    SizedBox(height: 2.h),
                    TextFieldWidget(text: "", obscureText: false, readOnly: false, controller: nameController,),
                    SizedBox(height: 16.h),
                    Text("Familiya", style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                    SizedBox(height: 2.h),
                    TextFieldWidget(text: "", obscureText: false, readOnly: false, controller: surnameController,),
                    SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed:isLoading
                        ? null
                        : () {
                      final fn = nameController.text.trim();
                      final ln = surnameController.text.trim();
                      if (fn.isEmpty || ln.isEmpty) return;
            
                      context.read<CustomerUpdateProfileBloc>().add(
                        CustomerUpdateProfileE(
                          name: fn, surname: ln,
                        ),
                      );
                    },
                    child:  Center(
                      child: isLoading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                      :  Text("Saqlash", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
