import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/service_info_widget.dart';

class WorkerInfoPage extends StatefulWidget {
  const WorkerInfoPage({super.key});

  @override
  State<WorkerInfoPage> createState() => _WorkerInfoPageState();
}

class _WorkerInfoPageState extends State<WorkerInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Ma'lumot",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/home/message.svg",
              width: 28,
              height: 28,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/circular_avatar/profile.png",
                  ),
                  radius: 50,
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jovidon Mahkamov",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Santexnik",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF4D4D4D),
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/home/star.svg",
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "4.4",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Flexible(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "923 ta baho va 257 ta sharh",
                                style: TextStyle(
                                  color: Color(0xff1778F2),
                                  fontSize: 15.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(child: Divider()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Xizmatlar",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        serviceInfoWidget(
                          iconPath: "assets/home/service.svg",
                          text: "6 yil",
                        ),
                        SizedBox(height: 12),
                        serviceInfoWidget(
                          iconPath: "assets/home/location.svg",
                          text: "2.4 km",
                        ),
                      ],
                    ),
                    SizedBox(width: 60.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        serviceInfoWidget(
                          iconPath: "assets/home/order.svg",
                          text: "100+ buyurtma",
                        ),
                        SizedBox(height: 12),
                        serviceInfoWidget(
                          iconPath: "assets/home/time.svg",
                          text: "~30 daqiqa",
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(child: Divider()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tajriba",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ReadMoreText("6 yildan beri santexnika ishlari bilan shug‘ullanaman."
                  "Oqish, kran, unitaz, truba muammolarini hal qilaman.",
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: " Read more",
                    trimExpandedText: " Read less",
                    style: TextStyle(fontSize: 14.sp),
                    moreStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                    lessStyle: TextStyle(
                      color: Color (0xff1778F2),
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            SizedBox(child: Divider()),

          ],
        ),
      ),
    );
  }
}
