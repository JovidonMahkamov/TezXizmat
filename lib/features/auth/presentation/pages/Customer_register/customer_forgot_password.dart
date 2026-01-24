import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_resend_email/customer_resend_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_resend_email/customer_resend_email_state.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';

class CustomerForgotPasswordPage extends StatefulWidget {
  const CustomerForgotPasswordPage({super.key});

  @override
  State<CustomerForgotPasswordPage> createState() =>
      _CustomerForgotPasswordPageState();
}

class _CustomerForgotPasswordPageState
    extends State<CustomerForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  String? errorMessage;

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

    BlocProvider.of<CustomerResendEmailBloc>(
      context,
    ).add(CustomerResendEmail(email: email,));
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
                SizedBox(height: 30.h),
                Text(
                  "Parolni unutdingizmi?",
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
                SizedBox(height: 40.h),

                /// EMAIL LABEL
                Text("Email", style: TextStyle(fontSize: 16.sp)),
                SizedBox(height: 8.h),

                /// EMAIL INPUT
                TextFieldWidget(
                  controller: emailController,
                  text: 'example@gmail.com',
                  obscureText: false,
                  readOnly: false,
                ),

                /// ERROR MESSAGE
                if (errorMessage != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],

                SizedBox(height: 40.h),

                BlocListener<CustomerResendEmailBloc, CustomerResendEmailState>(
                  listener: (context, state) {
                    if (state is CustomerResendEmailError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message, style: TextStyle()),
                        ),
                      );
                    }
                  },
                  child: BlocConsumer<CustomerResendEmailBloc, CustomerResendEmailState>(
                        listener: (context, state) {
                          if (state is CustomerResendEmailSuccess) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteNames.customerForgotPasswordOtp,
                              (route) => false,
                              arguments: {
                                "email": emailController.text.trim(),
                                "expires_at":
                                    state.customerResendEmailEntity.expires_at,
                              },
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is CustomerResendEmailLoading) {
                            return const Center(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballSpinFadeLoader,
                                  colors: [Colors.blueAccent],
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          } else {
                            return ElevatedWidget(
                              onPressed: signInUser,
                              text: 'Emailni tasdiqlash',
                              backgroundColor: Color(0xff1778F2),
                              textColor: Colors.white,
                            );
                          }
                        },
                      ),
                ),


                SizedBox(height: 20.h),

                /// LOGIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hisobingiz bormi?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.customerLogin);
                      },
                      child: const Text(
                        "Tizimga kirish",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
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
