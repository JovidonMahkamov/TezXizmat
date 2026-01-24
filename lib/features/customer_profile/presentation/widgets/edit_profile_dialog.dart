import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/update_profile_bloc/customer_update_profile_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/update_profile_bloc/customer_update_profile_state.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_event.dart';

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

        // ❌ Error bo‘lsa Snackbar
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

                  Text("Ism", style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),

                  SizedBox(height: 16.h),
                  Text("Familiya", style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: surnameController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),

                  SizedBox(height: 24.h),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
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
                      child: isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text("Saqlash"),
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
