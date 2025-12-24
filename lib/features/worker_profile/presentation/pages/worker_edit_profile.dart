import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/widgets/worker_image_picker_widget.dart';

class WorkerEditProfilePage extends StatefulWidget {
  const WorkerEditProfilePage({super.key});

  @override
  State<WorkerEditProfilePage> createState() => _WorkerEditProfilePageState();
}
String name = "Sevinch";
String surname = "Sharobidinova";

class _WorkerEditProfilePageState extends State<WorkerEditProfilePage> {

  final nameController = TextEditingController(text: name);
  final surnameController = TextEditingController(text: surname);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Profilni tahrirlash",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: WorkerImagePickerWidget()),
            SizedBox(height: 30.h,),
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
    );
  }

}
