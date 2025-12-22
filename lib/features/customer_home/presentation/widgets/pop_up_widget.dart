import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/success_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget_2.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final StringBuffer buffer = StringBuffer();

    const maxDigits = 9;

    for (int i = 0; i < newText.length && i < maxDigits; i++) {
      // Add space after 2nd digit (00 )
      if (i == 2) {
        buffer.write(' ');
      }
      // Add hyphen after 5th and 7th digits (00 000-00-00)
      if (i == 5 || i == 7) {
        buffer.write('-');
      }
      buffer.write(newText[i]);
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  TextEditingController phoneNumberController = TextEditingController();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Dialog(

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
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
                  "Telefon raqam",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: BoxBorder.all(color: Color(0xffCCCCCC), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70.w,
                        height: 46.h,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Color(0xffCCCCCC)),
                          ),
                        ),
                        child: Text("+998", style: TextStyle(fontSize: 16.sp)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12),
                            PhoneInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            hintText: "00 000-00-00",
                            hintStyle: TextStyle(color: Color(0xff94969A)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                          ),
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ],
                  ),
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
                SizedBox(height: 10.h),
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
      );
    },
  );
}
