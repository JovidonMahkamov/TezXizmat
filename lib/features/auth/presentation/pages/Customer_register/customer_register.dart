import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_state.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import '../../widgets/text_field_wodget_3.dart';

class CustomerRegisterPage extends StatefulWidget {
  const CustomerRegisterPage({super.key});

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  final TextEditingController emailController = TextEditingController();
  String? errorMessage;

  void signInUser() {
    final email = emailController.text.trim();

    /// Bo‘sh bo‘lsa
    if (email.isEmpty) {
      setState(() {
        errorMessage = "Emailni kiriting";
      });
      return;
    }
    /// Gmail (@.gmail.com)ni to'liq yozmagan taqdirda xatolik beradi
    if (!email.endsWith('@gmail.com')) {
      setState(() {
        errorMessage = "Gmail manzilingizni to‘liq kiriting";
      });
      return;
    }

    /// Hammasi to‘g‘ri bo‘lsa
    setState(() {
      errorMessage = null;
    });

    BlocProvider.of<CustomerSendEmailBloc>(
      context,
    ).add(CustomerSendEmail(email: email,));
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
              Navigator.pushNamed(context, RouteNames.select);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            // physics: const ClampingScrollPhysics(),
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
                TextFieldWidgetBoard(
                  controller: emailController,
                  text: 'emailingiz@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  obscureText: false, readOnly: false,
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

                SizedBox(height: 40.h),
                BlocListener<CustomerSendEmailBloc, CustomerSendEmailState>(
                  listener: (context, state) {
                    if (state is CustomerSendEmailError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message, style: TextStyle()),
                        ),
                      );
                    }
                  },
                  child: BlocConsumer<CustomerSendEmailBloc, CustomerSendEmailState>(
                    listener: (context, state) {
                      if (state is CustomerSendEmailSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.verificationOtp,(route) => false,
                            arguments: {"email":state.customerSendEmailEntity.email, "expires_at":state.customerSendEmailEntity.expires_in}
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CustomerSendEmailLoading) {
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
                          text: 'Emailni tasdiqlash', backgroundColor:  Color(0xff1778F2), textColor:  Colors.white,
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
                        Navigator.pushNamed(
                          context,
                          RouteNames.customerLogin,
                        );
                      },
                      child: const Text(
                        "Tizimga kirish",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
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
  }
}
