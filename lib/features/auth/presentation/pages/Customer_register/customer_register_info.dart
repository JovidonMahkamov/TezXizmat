import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';

class CustomerRegisterInfoPage extends StatefulWidget {
  const CustomerRegisterInfoPage({super.key});

  @override
  State<CustomerRegisterInfoPage> createState() =>
      _CustomerRegisterInfoPageState();
}

class _CustomerRegisterInfoPageState
    extends State<CustomerRegisterInfoPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _passwordError;
  String? _emailError;
  bool eye = true;
  bool eye1 = true;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
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

  void _validateEmail(String value) {
    if (value.isEmpty) {
      _emailError = "Emailni kiriting";
    } else if (!value.endsWith('@gmail.com')) {
      _emailError = "Gmail manzilingizni to‘liq kiriting";
    } else {
      _emailError = null;
    }
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnack("Iltimos, barcha maydonlarni to‘ldiring");
      return;
    }

    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);

    setState(() {});

    if (_emailError != null || _passwordError != null) return;

    if (_passwordController.text !=
        _confirmPasswordController.text) {
      _showSnack("Parollar bir xil emas");
      return;
    }

    /// ✅ HAMMASI TO‘G‘RI
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.customerLogin,
          (route) => false,
    );
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
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
                  ),

                  SizedBox(height: 25.h),

                  _label("Familiyangiz"),
                  TextFieldWidget(
                    controller: _surnameController,
                    text: "Familiyangizni kiriting",
                    obscureText: false,
                  ),

                  SizedBox(height: 25.h),

                  /// ✅ EMAIL FIELD (NOMER O‘RNIGA)
                  _label("Emailingiz"),
                  TextFieldWidget(
                    controller: _emailController,
                    text: "example@gmail.com",
                    obscureText: false,
                    errorText: _emailError,
                  ),

                  SizedBox(height: 25.h),

                  _label("Parol yarating"),
                  TextFieldWidget(
                    controller: _passwordController,
                    text: "********",
                    obscureText: eye,
                    errorText: _passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        eye ? IconlyLight.hide : IconlyLight.show,
                      ),
                      onPressed: () {
                        setState(() => eye = !eye);
                      },
                    ),
                  ),

                  SizedBox(height: 25.h),

                  _label("Parolni takrorlang"),
                  TextFieldWidget(
                    controller: _confirmPasswordController,
                    text: "********",
                    obscureText: eye1,
                    suffixIcon: IconButton(
                      icon: Icon(
                        eye1 ? IconlyLight.hide : IconlyLight.show,
                      ),
                      onPressed: () {
                        setState(() => eye1 = !eye1);
                      },
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    "Ro‘yxatdan o‘tish orqali siz "
                        "Foydalanish shartlari va "
                        "Maxfiylik siyosatimizga rozilik bildirasiz.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
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
      child: Text(
        text,
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }
}
