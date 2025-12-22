import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/order_Container_widget.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/order_Container_widgetTwo.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Buyurtmalar",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20.sp),
            child: Column(
              children: [
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "Faol",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "Yakunlangan",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "Bekor qilingan",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
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
                            OrderContainerWidget(
                              name: "Jovidon (Elektirik)",
                              description:
                                  "6 yildan beri elektrik bo'lib ishlab kelyabman",
                              time: "14:20",
                              statusText: "Yuborildi",
                              statusColor: Colors.orange,
                              imageUrl: "assets/circular_avatar/profile.png",
                              onViewTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.orderView,
                                );
                              },
                              onChatTap: () {
                                Navigator.pushNamed(
                                  context,
                                  arguments: {
                                    "name": "Jovidon (Elektrik)",
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
                            OrderContainerWidget(
                              name: "Jovidon (Elektirik)",
                              description:
                                  "6 yildan beri elektrik bo'lib ishlab kelyabman",
                              time: "14:20",
                              statusText: "Bajarildi",
                              statusColor: Colors.green,
                              imageUrl: "assets/circular_avatar/profile.png",
                              onViewTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.orderView,
                                );
                              },

                              onChatTap: () {
                                Navigator.pushNamed(
                                  context,
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
                            OrderContainerWidgetTwo(
                              name: "Jovidon (Elektirik)",
                              description:
                                  "6 yildan beri elektrik bo'lib ishlab kelyabman",
                              time: "14:20",
                              statusText: "Bekor qilindi",
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
      ),
    );
  }
}
