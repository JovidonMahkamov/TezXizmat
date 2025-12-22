import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/order_Container_with_Worker_widget.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/order_reject_or_not.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/reject_button_widget.dart';

class OrderViewPage extends StatefulWidget {
  const OrderViewPage({super.key});

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Ko’rib chiqilmoqda ",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.chatWithWorker,arguments: {
                "name":"Jovidon (Elektrik)",
                "urlAsset": "assets/circular_avatar/profile.png",
              });
            },
            icon: SvgPicture.asset("assets/home/message.svg"),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "Ijrochi hali buyurtmani qabul qilmagan. Javob berishi kutilmoqda...",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212121),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Color(0xffCCCCCC), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              height: 80,
            ),
            SizedBox(height: 20,),
            ViewContainerWorkerWidget(
              circularImage: AssetImage("assets/circular_avatar/profile.png"),
              nameText: "Jovidon (Elektrik)",
              experienceText:
                  "4 yildan beri elektrika ishlari bilan shug‘ullanaman ", time: '14:20',
            ),
            SizedBox(height: 300.h,),
            RejectButtonWidget(onPressed: (){
              showQuestionDialog(context);
            },
                text: "Jarayonni bekor qilish",
                backgroundColor: Colors.red,
                textColor: Colors.white),
          ],
        ),
      ),
    );
  }
}
