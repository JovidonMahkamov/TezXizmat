import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> images = [
    "assets/splash/onboarding_1.jpg",
    "assets/splash/onboarding_2.jpg",
    "assets/splash/onboarding_3.jpg",
  ];

  final List<String> generalText = [
    "Ishonchli Xizmat",
    "Ishonchli Mutaxassis",
    "To‘g‘ri Tanlov",
  ];
  final List<String> text = [
    "Uy va biznes xizmatlarini tez, qulay va ishonchli topish imkoni",
    "TezXizmat ilovasi bilan ishonchli mutaxassislarni topish endi oson!",
    "Biz sizga vaqtni tejash, ishonchli ijrochi topish va sifatli xizmat olish imkonini beramiz.",
  ];

  void _nextPage() {
    if (_currentPage < images.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to SignInPage
      Navigator.pushReplacementNamed(context, RouteNames.select);
    }
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
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 60.h),
              SizedBox(
                height: 400.h,
                width: 350.w,
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(images[index],width: double.infinity.w,height: 270.h, fit: BoxFit.cover),
                        ),
                         SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            children: [
                              Text(
                                generalText[_currentPage],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                text[_currentPage],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // SizedBox(height: 50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  bool isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8.w,
                    width: isActive ? 32.w : 8.w,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.blueAccent
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }),
              ),
              Expanded(child: SizedBox()),
              Stack(
                children: [
                  SizedBox(
                    width: w * 1.w,
                    height: 261.h,
                    child: SvgPicture.asset(
                      'assets/splash/ellipse.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 44,
                    child: Container(
                      width: 200.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 2),
                          left: BorderSide(color: Colors.white, width: 2),
                          bottom: BorderSide(color: Colors.white, width: 2),
                          right: BorderSide.none,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff1778F2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                        child: Text(
                          _currentPage == images.length - 1
                              ? "Boshlash"
                              : "Davom etish",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 162,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.select,
                              (route) => false,
                        );
                      },
                      child: Text(
                        "O'tkazib yuborish",
                        style: TextStyle(
                          color: Color(0xffD9D9D9),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
