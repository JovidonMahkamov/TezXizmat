import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';

class CustomerForgotPasswordOtpPage extends StatefulWidget {
  final String phoneNumber;

  const CustomerForgotPasswordOtpPage({super.key, required this.phoneNumber});

  @override
  State<CustomerForgotPasswordOtpPage> createState() => _CustomerForgotPasswordOtpPageState();
}

class _CustomerForgotPasswordOtpPageState extends State<CustomerForgotPasswordOtpPage> {
  final TextEditingController otpController = TextEditingController();

  String _otp = "";
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    if (!_canResend) return;

    otpController.clear();

    setState(() {
      _otp = "";
    });

    _startTimer();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Yangi kod yuborildi")));
  }

  bool get _isButtonEnabled => _otp.length == 6;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Text(
                  "Tasdiqlash kodini kiriting",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Tasdiqlash kodi ${widget.phoneNumber} emailga yuborildi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF757C9A),
                  ),
                ),
                SizedBox(height: 40.h),
                Pinput(
                  controller: otpController,
                  length: 6,
                  onChanged: (value) {
                    setState(() {
                      _otp = value;
                    });
                  },
                  onCompleted: (pin) {
                    setState(() {
                      _otp = pin;
                    });
                  },
                  defaultPinTheme: PinTheme(
                    width: 83,
                    height: 61,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xffCCCCCC)),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 83,
                    height: 61,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue, width: 1.3),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Emailga kelgan kodni kiriting",
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
                SizedBox(height: 48.h),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.customerNewPassword,
                            (route) => false,
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled
                          ? const Color(0xff1778F2)
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Tasdiqlash",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                /// Resend section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _canResend
                          ? "Kod kelmadimi?"
                          : "Qayta yuborish $_secondsRemaining s",
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: _canResend ? _resendCode : null,
                      child: Text(
                        "Qayta yuborish",
                        style: TextStyle(
                          color: _canResend
                              ? Colors.blue
                              : Colors.grey.shade400,
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
