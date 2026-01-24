import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/success_widget.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_create_order/customer_create_order_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_create_order/customer_create_order_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';

class CreateOrderDialog extends StatefulWidget {
  final int staffId;

  const CreateOrderDialog({
    super.key,
    required this.staffId,
  });

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController addressController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    addressController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerCreateOrderBloc, CustomerCreateOrderState>(
      listener: (context, state) {
        if (state is CustomerCreateOrderSuccess) {
          Navigator.pop(context);
          showSuccessDialogTwo(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Buyurtma yuborildi ✅")),
          );
        }

        if (state is CustomerCreateOrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CustomerCreateOrderLoading;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ma’lumotlaringizni kiriting",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: isLoading ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close_outlined),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text("Ism", style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Ismingizni kiriting",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10.h),
                  Text("Familiya", style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: surnameController,
                    decoration: const InputDecoration(
                      hintText: "Familiyangizni kiriting",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10.h),
                  Text("Manzil", style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      hintText: "Manzilingizni kiriting",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10.h),
                  Text("Batafsil", style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Muammoingiz haqida batafsil...",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                        final name = nameController.text.trim();
                        final surname = surnameController.text.trim();
                        final address = addressController.text.trim();
                        final desc = descriptionController.text.trim();

                        if (name.isEmpty || surname.isEmpty || address.isEmpty || desc.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Hamma maydonlarni to‘ldiring")),
                          );
                          return;
                        }

                        context.read<CustomerCreateOrderBloc>().add(
                          CustomerCreateOrder(
                            staff_id: widget.staffId,
                            name: name,
                            surname: surname,
                            address: address,
                            description: desc,
                          ),
                        );
                      },
                      child: isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text("Jo'natish"),
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

