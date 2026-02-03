import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.select);
    }
  }

  void _skip() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.select,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              // yuqori bo‘shliq (kichik qilib qo‘ydik)
              SizedBox(height: 16.h),

              // Asosiy kontent: PageView + textlar
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: images.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          // Rasm joyi: ekranga moslashadi
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.asset(
                                images[index],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(height: 14.h),

                          Text(
                            generalText[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              text[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),

                          SizedBox(height: 10.h),
                        ],
                      ),
                    );
                  },
                ),
              ),

              //  indikator
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (i) {
                  final isActive = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8.w,
                    width: isActive ? 30.w : 8.w,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.blueAccent : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }),
              ),
              SizedBox(height: 10.h),

              //  Pastki ellipse qismi (height fixed emas)
              // Buni AspectRatio bilan boshqaramiz — hamma ekranda chiqadi.
              SizedBox(
                width: size.width,
                child: AspectRatio(
                  aspectRatio: 375 / 180, // ellipse svg taxminiy nisbat
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/splash/ellipse.svg',
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Skip
                      Positioned(
                        left: 16.w,
                        top: 12.h,
                        child: TextButton(
                          onPressed: _skip,
                          child: Text(
                            "O'tkazib yuborish",
                            style: TextStyle(
                              color: const Color(0xffD9D9D9),
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),

                      // Button
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
                    ],
                  ),
                ),
              ),

              // Pastda kichkina SafeArea gap
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}
