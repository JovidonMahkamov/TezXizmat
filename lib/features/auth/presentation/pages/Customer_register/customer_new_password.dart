import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_reset_password/customer_reset_password_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_reset_password/customer_reset_password_state.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';

class CustomerNewPasswordPage extends StatefulWidget {
  final String email;
  const CustomerNewPasswordPage({super.key,required this.email});

  @override
  State<CustomerNewPasswordPage> createState() =>
      _CustomerNewPasswordPageState();
}

class _CustomerNewPasswordPageState extends State<CustomerNewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _passwordError;
  bool eye = true;
  bool eye1 = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword(String value) {
    if (value.length < 8) {
      _passwordError = "Parol kamida 8 ta belgidan iborat bo‘lishi kerak";
    } else {
      _passwordError = null;
    }
  }

  String formatPhoneNumber(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 9) return "";
    return "+998$cleaned";
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnack("Iltimos, barcha maydonlarni to‘ldiring");
      return;
    }

    _validatePassword(_passwordController.text);
    if (_passwordError != null) {
      setState(() {});
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnack("Parollar bir xil emas");
      return;
    }
    BlocProvider.of<CustomerResetPasswordBloc>(context).add(
      CustomerResetPassword(
        email: widget.email,
        password: _passwordController.text.trim(),
        confirm_password: _confirmPasswordController.text.trim(),
      ),
    );
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40.h),

                  Text(
                    "Yangi kod kiritish",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 40.h),
                  _label("Parol yarating"),
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
                    readOnly: false,
                  ),

                  SizedBox(height: 25.h),

                  _label("Parolni takrorlang"),
                  TextFieldWidget(
                    controller: _confirmPasswordController,
                    text: "********",
                    obscureText: eye1,
                    suffixIcon: IconButton(
                      icon: Icon(eye1 ? IconlyLight.hide : IconlyLight.show),
                      onPressed: () {
                        setState(() => eye1 = !eye1);
                      },
                    ),
                    readOnly: false,
                  ),

                  SizedBox(height: 30.h),

                  BlocListener<
                    CustomerResetPasswordBloc,
                    CustomerResetPasswordState
                  >(
                    listener: (context, state) {
                      if (state is CustomerResetPasswordError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message, style: TextStyle()),
                          ),
                        );
                      }
                    },
                    child:
                        BlocConsumer<
                          CustomerResetPasswordBloc,
                          CustomerResetPasswordState
                        >(
                          listener: (context, state) {
                            if (state is CustomerResetPasswordSuccess) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.customerLogin,
                                (route) => false,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is CustomerResetPasswordLoading) {
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
                              return SizedBox(
                                width: double.infinity,
                                height: 47.h,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Parolni saqlash",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(fontSize: 16.sp)),
    );
  }
}
