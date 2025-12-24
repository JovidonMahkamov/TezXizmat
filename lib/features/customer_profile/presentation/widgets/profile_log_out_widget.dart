import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';

void showQuestionLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Profildan chiqishni xohlaysizmi?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child:
                      ElevatedWidget(onPressed: (){
                        Navigator.pop(context);
                      }, text: "Yo'q", backgroundColor: Colors.grey.shade200, textColor: Colors.black)
                  ),
                  SizedBox(width: 20.w,),
                  Expanded(
                      child:
                      ElevatedWidget(onPressed: (){
                        Navigator.pop(context);
                      }, text: "Ha", backgroundColor: Colors.blue, textColor: Colors.white)

                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
