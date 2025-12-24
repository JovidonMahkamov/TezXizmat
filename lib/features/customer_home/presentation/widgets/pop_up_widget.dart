import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/success_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget_2.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding:  EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.close_outlined)),
                    ],

                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ism",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8.h),
                  TextFieldWidget(text: "Ismingizni kiriting", obscureText: false),
                  SizedBox(height: 10.h),
                  Text(
                    "Familiya",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8.h),
                  TextFieldWidget(
                    text: "Familiyangizni kiriting",
                    obscureText: false,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Manzil",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8.h),
                  TextFieldWidgetTwo(
                    maxLine: 1,
                    text: "Manzilingizni kiriting",
                    obscureText: false,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Batafsil",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8.h),
                  TextFieldWidgetTwo(
                    maxLine: 3,
                    text: "Muammoingiz haqida batafsil...",
                    obscureText: false,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50 ,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                              showSuccessDialogTwo(context);
                            },
                            child: Text("Jo'natish"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
