import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';


void showSuccessDialogTwo(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: SizedBox(
          width: 320.w,
          height: 420.h,
          child: Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              right: 14.w,
              top: 30.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/home/success.svg",
                  height: 100.h,
                ),
                SizedBox(height: 35.h),
                Text(
                  "Muvaffaqiyatli",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212121),
                  ),
                ),
                SizedBox(height: 12.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Eslatma: ",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text:
                        "Agar siz buyurtmani bekor qilmoqchi bo‘lsangiz, ijrochi tasdiqlaguncha bekor qilishingiz mumkin. "
                            "Aks holda buyurtmani bekor qila olmaysiz!",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xff4D4D4D),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 34,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50 ,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, RouteNames.customerBottomNavBar);
                          },
                          child: Text("Tasdiqlash"),
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
      );
    },
  );
}
