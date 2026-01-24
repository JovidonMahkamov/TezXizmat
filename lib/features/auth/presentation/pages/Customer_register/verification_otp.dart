import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pinput/pinput.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_auth_event.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_state.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_verify_email/customer_verify_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_verify_email/customer_verify_email_state.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final String expires_at;

  const VerificationPage({
    super.key,
    required this.email,
    required this.expires_at,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController otpController = TextEditingController();

  late DateTime _expiresAt;
  Timer? _timer;

  String _otp = "";
  Duration _remaining = Duration.zero;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    // expires_at ni birinchi init qilib ol
    _expiresAt = DateTime.parse(widget.expires_at).toLocal();

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

    // darhol 1 marta hisoblab qo'yamiz (UI yangilansin)
    _syncRemaining();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      _syncRemaining();

      if (_canResend) {
        timer.cancel();
      }
    });
  }

  void _syncRemaining() {
    final now = DateTime.now();
    final diff = _expiresAt.difference(now);

    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
      _canResend = _remaining == Duration.zero;
    });
  }

  void _resendCode() {
    if (!_canResend) return;

    otpController.clear();
    setState(() => _otp = "");

    // resend => API chaqiradi
    context.read<CustomerSendEmailBloc>().add(
      CustomerSendEmail(email: widget.email),
    );
  }

  bool get _isButtonEnabled => _otp.length == 6;

  String get _remainingText {
    final seconds = _remaining.inSeconds;
    if (seconds <= 0) return "0";
    return seconds.toString();
  }

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
                  "Tasdiqlash kodi ${widget.email} emailga yuborildi",
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
                  onChanged: (value) => setState(() => _otp = value),
                  onCompleted: (pin) => setState(() => _otp = pin),
                  defaultPinTheme: PinTheme(
                    width: 83,
                    height: 61,
                    textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xffCCCCCC)),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 83,
                    height: 61,
                    textStyle: const TextStyle(fontSize: 20, color: Colors.black),
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

                /// Verify listeners
                BlocListener<CustomerVerifyEmailBloc, CustomerVerifyEmailState>(
                  listener: (context, state) {
                    if (state is CustomerVerifyEmailError) {
                      otpController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.message),
                        ),
                      );
                    }
                  },
                  child: BlocConsumer<CustomerVerifyEmailBloc, CustomerVerifyEmailState>(
                    listener: (context, state) {
                      if (state is CustomerVerifyEmailSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.customerRegisterInfo,
                              (route) => false,
                          arguments: widget.email,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CustomerVerifyEmailLoading) {
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
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled
                              ? () {
                            context.read<CustomerVerifyEmailBloc>().add(
                              CustomerVerifyEmail(
                                email: widget.email,
                                // bu joy backendga qarab "code/otp" bo'lishi kerak
                                password: otpController.text.trim(),
                              ),
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
                      );
                    },
                  ),
                ),

                SizedBox(height: 30.h),

                /// Resend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _canResend ? "Kod kelmadimi?" : "Qayta yuborish $_remainingText s",
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),

                    BlocListener<CustomerSendEmailBloc, CustomerSendEmailState>(
                      listener: (context, state) {
                        if (state is CustomerSendEmailSuccess) {
                          // ✅ yangi expires_at ni olib, timer restart qilamiz
                          setState(() {
                            _expiresAt = DateTime.parse(
                              state.customerSendEmailEntity.expires_at,
                            ).toLocal();
                          });
                          _startTimer();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Yangi kod yuborildi")),
                          );
                        }

                        if (state is CustomerSendEmailError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      child: TextButton(
                        onPressed: _canResend ? _resendCode : null,
                        child: Text(
                          "Qayta yuborish",
                          style: TextStyle(
                            color: _canResend ? Colors.blue : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    )
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
