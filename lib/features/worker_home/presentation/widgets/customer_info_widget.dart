import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';


void customerShowInfoWidget(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Mijozning ma’lumotlari",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close_outlined),
                    ),
                  ],
                ),
                SizedBox(child: Divider()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.h,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Ism: ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Jovidon",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h,),
                    SizedBox(child: Divider(),),
                    SizedBox(height: 6.h,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Familiya: ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Mahkamov",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h,),
                    SizedBox(child: Divider(),),
                    SizedBox(height: 6.h,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Manzil: ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Tashkent, sergeli, Uzumzor 4-berk ko’cha",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h,),
                    SizedBox(child: Divider(),),
                    SizedBox(height: 6.h,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Batafsil: ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                "Uyda quvur buzildi, zudlik bilan to'g'irlash kerak, yana bir ikki elektr muammolari bor. Uyda quvur buzildi, zudlik bilan to'g'irlash kerak, yana bir ikki elektr muammolari bor.",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h,),
                    SizedBox(child: Divider(),),
                  ],
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedWidget(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Rad etish",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: ElevatedWidget(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Qabul qilish",
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
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
