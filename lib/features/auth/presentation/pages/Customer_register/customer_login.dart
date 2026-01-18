import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tez_xizmat/core/di/services_locator.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/core/untils/logger.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_login/customer_login_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_login/customer_login_state.dart';
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
  final authLocalDataSource = sl<AuthLocalDataSource>();

  String? errorMessage;
  String? _passwordError;
  void _validatePassword(String value) {
    if (value.length < 8) {
      _passwordError = "Parol kamida 8 ta belgidan iborat bo‘lishi kerak";
    } else {
      _passwordError = null;
    }
  }

  void saveAuthAccessToken(String token) {
    authLocalDataSource
        .saveAccessToken(token)
        .then((_) {
      LoggerService.info("Auth AccessToken saved : $token");
    })
        .catchError((error) {
      LoggerService.error("Error saving Auth Token: $error");
    });
  }
  void saveAuthRefreshToken(String token) {
    authLocalDataSource
        .saveRefreshToken(token)
        .then((_) {
      LoggerService.info("Auth RefreshToken saved : $token");
    })
        .catchError((error) {
      LoggerService.error("Error saving Auth Token: $error");
    });
  }


  void saveRememberMe(String email, String password) {
    authLocalDataSource
        .saveRememberMe(email, password)
        .then((_) {
      LoggerService.info("Remember Me saved : $email - $password");
    })
        .catchError((error) {
      LoggerService.error("Error saving Remember Me: $error");
    });
  }


  void signInUser() {
    final email = emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (email.isEmpty) {
      setState(() => errorMessage = "Emailni kiriting");
      return;
    }

    if (!email.endsWith('@gmail.com')) {
      setState(() => errorMessage = "Gmail manzilingizni to‘liq kiriting");
      return;
    }

    setState(() => errorMessage = null);

    _validatePassword(pass);
    if (_passwordError != null) {
      setState(() {});
      return;
    }

    context.read<CustomerLoginBloc>().add(
      CustomerLogin(email: email, password: pass),
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
                  "Tizimga kirish",
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 40.h),

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
                  ), readOnly: false,
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

                BlocConsumer<CustomerLoginBloc, CustomerLoginState>(
                  listener: (context, state) {
                    if (state is CustomerLoginSuccess) {
                      saveRememberMe(
                        emailController.text,
                        _passwordController.text,
                      );
                      saveAuthAccessToken(state.customerLoginEntity.access);
                      saveAuthRefreshToken(state.customerLoginEntity.refresh);

                      final role = authLocalDataSource.getRole() ?? 'customer';

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        role == 'staff'
                            ? RouteNames.workerBottomNavBar
                            : RouteNames.customerBottomNavBar,
                            (route) => false,
                      );

                    }

                    if (state is CustomerLoginError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is CustomerLoginLoading) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballSpinFadeLoader,
                              colors: [Colors.blueAccent],
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      );
                    }

                    return ElevatedWidget(
                      onPressed: signInUser,
                      text: 'Tizimga kirish',
                      backgroundColor: const Color(0xff1778F2),
                      textColor: Colors.white,
                    );
                  },
                ),
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
