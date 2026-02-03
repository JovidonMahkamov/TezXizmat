import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_register/customer_register_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_register/customer_register_state.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_wodget_3.dart';


class CustomerRegisterInfoPage extends StatefulWidget {
  final String email;

  const CustomerRegisterInfoPage({super.key, required this.email});

  @override
  State<CustomerRegisterInfoPage> createState() => _CustomerRegisterInfoPageState();
}

class _CustomerRegisterInfoPageState extends State<CustomerRegisterInfoPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _passwordError;
  String? _confirmPasswordError;
  String? _emailError;

  bool eye = true;
  bool eye1 = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    if (value.isEmpty) {
      _emailError = "Emailni kiriting";
    } else if (!value.endsWith('@gmail.com')) {
      _emailError = "Gmail manzilingizni to‘liq kiriting";
    } else {
      _emailError = null;
    }
  }

  ///  Password rules:
  /// - >=8
  /// - has letter
  /// - has digit
  String? _passwordRuleError(String value) {
    final v = value.trim();

    if (v.isEmpty) return "Parol yarating";
    if (v.length < 8) return "Parol kamida 8 ta belgidan iborat bo‘lishi kerak";

    final hasDigit = RegExp(r'\d').hasMatch(v);
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(v);

    // faqat raqam bo‘lsa
    if (hasDigit && !hasLetter) return "Harf ham qo‘shing (masalan: a, b, A...)";

    // faqat harf bo‘lsa
    if (hasLetter && !hasDigit) return "Raqam ham qo‘shing (masalan: 1,2,3...)";

    // ikkalasi ham bor — ok
    return null;
  }

  void _validatePassword(String value) {
    _passwordError = _passwordRuleError(value);
  }

  void _validateConfirmPassword(String value) {
    _confirmPasswordError = _passwordRuleError(value);
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_nameController.text.trim().isEmpty ||
        _surnameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnack("Iltimos, barcha maydonlarni to‘ldiring");
      return;
    }

    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);
    _validateConfirmPassword(_confirmPasswordController.text);

    setState(() {});

    if (_emailError != null || _passwordError != null || _confirmPasswordError != null) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnack("Parollar bir xil emas");
      return;
    }

    context.read<CustomerRegisterBloc>().add(
      CustomerRegister(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        confirm_password: _confirmPasswordController.text.trim(),
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
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
                    "Ma’lumotlaringizni kiriting",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  _label("Ismingiz"),
                  TextFieldWidget(
                    controller: _nameController,
                    text: "Ismingizni kiriting",
                    obscureText: false,
                    readOnly: false,
                  ),

                  SizedBox(height: 25.h),

                  _label("Familiyangiz"),
                  TextFieldWidget(
                    controller: _surnameController,
                    text: "Familiyangizni kiriting",
                    obscureText: false,
                    readOnly: false,
                  ),

                  SizedBox(height: 25.h),

                  _label("Emailingiz"),
                  TextFieldWidget(
                    controller: _emailController,
                    text: widget.email,
                    obscureText: false,
                    errorText: _emailError,
                    readOnly: true,
                  ),

                  SizedBox(height: 25.h),

                  _label("Parol yarating"),
                  TextFieldWidgetBoard(
                    controller: _passwordController,
                    text: "********",
                    obscureText: eye,
                    errorText: _passwordError,
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (v) {
                      setState(() {
                        _validatePassword(v);
                      });
                    },
                    suffixIcon: IconButton(
                      icon: Icon(eye ? IconlyLight.hide : IconlyLight.show),
                      onPressed: () => setState(() => eye = !eye),
                    ),
                    readOnly: false,
                  ),

                  SizedBox(height: 25.h),

                  _label("Parolni takrorlang"),
                  TextFieldWidgetBoard(
                    controller: _confirmPasswordController,
                    text: "********",
                    obscureText: eye1,
                    errorText: _confirmPasswordError,
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (v) {
                      setState(() {
                        _validateConfirmPassword(v);
                      });
                    },
                    suffixIcon: IconButton(
                      icon: Icon(eye1 ? IconlyLight.hide : IconlyLight.show),
                      onPressed: () => setState(() => eye1 = !eye1),
                    ),
                    readOnly: false,
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    "Ro‘yxatdan o‘tish orqali siz "
                        "Foydalanish shartlari va "
                        "Maxfiylik siyosatimizga rozilik bildirasiz.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),

                  SizedBox(height: 20.h),

                  BlocListener<CustomerRegisterBloc, CustomerRegisterState>(
                    listener: (context, state) {
                      if (state is CustomerRegisterError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(state.message),
                          ),
                        );
                      }
                    },
                    child: BlocConsumer<CustomerRegisterBloc, CustomerRegisterState>(
                      listener: (context, state) {
                        if (state is CustomerRegisterSuccess) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteNames.customerLogin,
                                (route) => false,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is CustomerRegisterLoading) {
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
                        }

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
                              "Ro'yxatdan o'tish",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
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
