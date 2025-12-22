import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/pop_up_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/rating_info_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/service_info_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/service_widget.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                onPressed: () {
                                  showRatingSheet(context);
                                },
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
                    "Ishchi Ma'lumotlari",
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
                  ReadMoreText(
                    "6 yildan beri santexnika ishlari bilan shug‘ullanaman."
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
                      color: Color(0xff1778F2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(child: Divider()),
              Text(
                "Xizmatlar",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10.h),
              serviceWidget(text: 'Kranni tamirlash'),
              serviceWidget(text: 'quvur almashtirish'),
              serviceWidget(text: 'Oqishlarni tuzatish'),
              SizedBox(child: Divider()),
              Text(
                "Narx",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10.h),
              Text(
                "50 000 so‘mdan boshlanadi",
                style: TextStyle(fontSize: 14.sp,color: Color(0xff4D4D4D)),
              ),
              SizedBox(child: Divider(),),
              Text(
                "Mavjud vaqt",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10.h),
              Text(
                "Bugun: 09:00 - 20:00",
                style: TextStyle(fontSize: 14.sp,color: Color(0xff4D4D4D)),
              ),
              SizedBox(child: Divider(),),
              SizedBox(height: 20.h,),
              ElevatedWidget(onPressed: (){
                showSuccessDialog(context);
              }, text: "Bog'lanish", backgroundColor:  Color(0xff1778F2), textColor: Colors.white,),
              SizedBox(height: 30.h,),
            ],
          ),
        ),
      ),
    );
  }
}








