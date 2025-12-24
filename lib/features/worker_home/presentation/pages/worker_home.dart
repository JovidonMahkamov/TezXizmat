import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_carousel_widget.dart';
import 'package:tez_xizmat/features/worker_home/presentation/widgets/customer_info_widget.dart';
import 'package:tez_xizmat/features/worker_home/presentation/widgets/home_worker_app_bar_widget.dart';
import 'package:tez_xizmat/features/worker_home/presentation/widgets/order_widget.dart';
import 'package:tez_xizmat/features/worker_home/presentation/widgets/order_widget_two.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: HomeWorkerAppBarWidget(),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              HomeCarouselWidget(),
              SizedBox(height: 10.h),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Buyurtmalar",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 10.h),
                      PreferredSize(
                        preferredSize: const Size.fromHeight(70),
                        child: TabBar(
                          indicatorColor: Colors.blueAccent,
                          tabAlignment: TabAlignment.center,
                          dividerColor: Colors.transparent,
                          isScrollable: true,
                          labelColor: Colors.blueAccent,
                          unselectedLabelColor: Color(0xffB8BFE1),
                          labelStyle: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: const [
                            Tab(
                              child: Text(
                                "Faol",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Yakunlangan",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Bekor qilingan",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 23.h),
                                  OrderWidget(
                                    name: "Sevinch",
                                    description:
                                    "Uyda quvur buzildi, zudlik bilan to'g'irlash kerak, yana bir ikki elektr muammolari bor",
                                    time: "14:20",
                                    statusText: "Hali qabul kilmadingiz",
                                    statusColor: Colors.orange,
                                    imageUrl: "assets/circular_avatar/profile.png",
                                    onViewTap: () {
                                      customerShowInfoWidget(context);
                                    },
                                    onChatTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        arguments: {
                                          "name": "Jovidon",
                                          "urlAsset":
                                          "assets/circular_avatar/profile.png",
                                        },
                                        RouteNames.chatWithWorker,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 23.h),
                                  OrderWidgetTwo(
                                    name: "Jovidon",
                                    description:
                                    "Uyda quvur buzildi, zudlik bilan to'g'irlash kerak, yana bir ikki elektr muammolari bor",
                                    time: "14:20",
                                    statusText: "Ish muvaffaqiyatli yakunlangan",
                                    statusColor: Colors.green,
                                    imageUrl: "assets/circular_avatar/profile.png",
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 23.h),
                                  OrderWidgetTwo(
                                    name: "Jovidon",
                                    description:
                                    "Uyda quvur buzildi, zudlik bilan to'g'irlash kerak, yana bir ikki elektr muammolari bor",
                                    time: "14:20",
                                    statusText: "Ishni bekor qilgansiz",
                                    statusColor: Colors.red,
                                    imageUrl: "assets/circular_avatar/profile.png",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
