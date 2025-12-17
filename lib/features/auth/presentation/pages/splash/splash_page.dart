import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Navigate to RegisterPage after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.carousel,(route) => false,);
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.38.h),
            SvgPicture.asset(
              'assets/splash/logo.svg',
              height: 70.h,
              width: 170.w,
            ),
            Expanded(child: SizedBox()),
            SizedBox(
              width: double.infinity,
              height: 261.h,
              child: SvgPicture.asset(
                'assets/splash/ellipse.svg',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
