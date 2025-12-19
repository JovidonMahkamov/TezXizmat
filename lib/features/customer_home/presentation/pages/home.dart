import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_app_bar_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_carousel_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_circular_avatar_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_container_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            HomeCarouselWidget(),
            SizedBox(height: 15.h),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xizmatlar",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HomeCircularAvatarWidget(
                          iconAvatar: SvgPicture.asset(
                            "assets/circular_avatar/elektirik.svg",
                          ),
                          circularColor: Color(0xffF0FAF2),
                          title: 'Elektrik',
                        ),
                        SizedBox(width: 18.w),
                        HomeCircularAvatarWidget(
                          iconAvatar: SvgPicture.asset(
                            "assets/circular_avatar/santexnik.svg",
                          ),
                          circularColor: Color(0xffE5F3FB),
                          title: 'Santexnik',
                        ),
                        SizedBox(width: 18.w),
                        HomeCircularAvatarWidget(
                          iconAvatar: SvgPicture.asset(
                            "assets/circular_avatar/culler.svg",
                          ),
                          circularColor: Color(0xffF4EAFB),
                          title: 'Konditsioner ustasi',
                        ),
                        SizedBox(width: 18.w),
                        HomeCircularAvatarWidget(
                          iconAvatar: SvgPicture.asset(
                            "assets/circular_avatar/cleaner.svg",
                          ),
                          circularColor: Color(0xffFFE5EA),
                          title: 'Uy tozalovchi',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Yaqin atrofingizdagi ishchilar",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  HomeContainerWidget(
                    circularImage: AssetImage(
                      "assets/circular_avatar/profile.png",
                    ),
                    nameText: "Jovidon (Elektrik)",
                    experienceText: "6 yildan beri elektrika ishlari bilan shug‘ullanaman ",
                  ),
                  HomeContainerWidget(
                    circularImage: AssetImage(
                      "assets/circular_avatar/profile1.png",
                    ),
                    nameText: "Firdavs (Santexnik)",
                    experienceText: "4 yildan beri elektrika ishlari bilan shug‘ullanaman ",
                  ),
                  HomeContainerWidget(
                    circularImage: AssetImage(
                      "assets/circular_avatar/profile.png",
                    ),
                    nameText: "Jovidon (Elektrik)",
                    experienceText: "6 yildan beri elektrika ishlari bilan shug‘ullanaman ",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
