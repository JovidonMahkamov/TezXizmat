import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  final TextEditingController emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? errorMessage;
  String? _passwordError;
  void _validatePassword(String value) {
    if (value.length < 8) {
      _passwordError = "Parol kamida 8 ta belgidan iborat bo‘lishi kerak";
    } else {
      _passwordError = null;
    }
  }

  void signInUser() {
    final email = emailController.text.trim();

    // 1️⃣ Bo‘sh bo‘lsa
    if (email.isEmpty) {
      setState(() {
        errorMessage = "Emailni kiriting";
      });
      return;
    }

    // 2️⃣ Gmail emas bo‘lsa
    if (!email.endsWith('@gmail.com')) {
      setState(() {
        errorMessage = "Gmail manzilingizni to‘liq kiriting";
      });
      return;
    }

    // 3️⃣ Hammasi to‘g‘ri bo‘lsa
    setState(() {
      errorMessage = null;
    });
    _validatePassword(_passwordController.text);
    if (_passwordError != null) {
      setState(() {});
      return;
    }

    Navigator.pushNamed(
      context,
      RouteNames.bottomNavBar,
      arguments: email,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  bool eye = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  "Ro’yxatdan o’tish",
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Emailingizga 6 xonali tasdiqlash kodi yuboriladi.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 60.h),

                /// EMAIL LABEL
                Text(
                  "Email",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 8.h),

                /// EMAIL INPUT
                TextFieldWidget(
                  controller: emailController,
                  text: 'example@gmail.com',
                  obscureText: false,
                ),

                /// ERROR MESSAGE
                if (errorMessage != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],

                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Parol", style: TextStyle(fontSize: 16.sp)),
                ),
                TextFieldWidget(
                  controller: _passwordController,
                  text: "********",
                  obscureText: eye,
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(eye ? IconlyLight.hide : IconlyLight.show),
                    onPressed: () {
                      setState(() => eye = !eye);
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.customerForgotPassword,
                      );
                    },
                    child: Text(
                      "Parolni unutdingizmi ?",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                ElevatedWidget(onPressed: signInUser, text: 'Tizimga kirish', backgroundColor:  Color(0xff1778F2), textColor:  Colors.white,),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hisobingiz yoqmi ?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.customerRegister,
                        );
                      },
                      child: Text(
                        "Ro'yxatdan o'tish",
                        style: TextStyle(color: Colors.blue, fontSize: 16.sp),
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
  }
}
