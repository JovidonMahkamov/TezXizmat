import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/order_Container_with_Worker_widget.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/order_reject_or_not.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/reject_button_widget.dart';

import '../bloc/cancel_order/cancel_order_bloc.dart';
import '../bloc/cancel_order/cancel_order_state.dart';
import '../bloc/confirm_completion_order/confirm_completion_bloc.dart';
import '../bloc/confirm_completion_order/confirm_completion_state.dart';
import '../bloc/customer_order_event.dart';
import '../bloc/get_customer_all_orders/get_customer_all_orders_bloc.dart';

class OrderViewPage extends StatefulWidget {
  final GetAllOrdersEntity order;
  const OrderViewPage({super.key, required this.order});

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {

  bool get canCancel =>
      (widget.order.acceptedAt == null || widget.order.acceptedAt!.isEmpty) &&
          (widget.order.status.toUpperCase() == 'PENDING');

  bool get isAccepted =>
      (widget.order.acceptedAt != null && widget.order.acceptedAt!.isNotEmpty) ||
          widget.order.status.toUpperCase() == 'ACCEPTED';

  bool get isStarted =>
      (widget.order.startedAt != null && widget.order.startedAt!.isNotEmpty) ||
          widget.order.status.toUpperCase() == 'IN_PROGRESS' ||
          widget.order.status.toUpperCase() == 'STARTED';

  bool get staffCompleted =>
      (widget.order.completedByStaffAt != null && widget.order.completedByStaffAt!.isNotEmpty);

  bool get customerCompleted =>
      (widget.order.completedByCustomerAt != null && widget.order.completedByCustomerAt!.isNotEmpty) ||
          widget.order.status.toUpperCase() == 'COMPLETED';

  @override
  Widget build(BuildContext context) {
    // 1) Button matn + enabled
    String buttonText;
    bool enabled;
    Color color;

    if (customerCompleted) {
      buttonText = "Yakunlangan";
      enabled = false;
      color = Colors.green;
    } else if (isStarted) {
      buttonText = "Ish yakunlandi";
      enabled = staffCompleted; // faqat staff complete-by-staff qilsa ishlaydi
      color = enabled ? Colors.green : Colors.green.shade200;
    } else if (isAccepted) {
      buttonText = "Jarayon bekor qilib bo‘lmaydi";
      enabled = false;
      color = Colors.orange.shade200;
    } else {
      buttonText = "Jarayonni bekor qilish";
      enabled = canCancel;
      color = Colors.red;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<CancelOrderBloc, CancelOrderState>(
          listener: (context, state) {
            if (state is CancelOrderSuccess) {
              context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE());
              Navigator.pop(context); // order viewdan chiqib ketish ixtiyoriy
            }
          },
        ),
        BlocListener<ConfirmCompletionBloc, ConfirmCompletionState>(
          listener: (context, state) {
            if (state is ConfirmCompletionSuccess) {
              context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE());
              // TODO: rating page (keyin ulaysan)
            }
          },
        ),
      ],
      child: Scaffold(
        // ...
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: RejectButtonWidget(
            text: buttonText,
            backgroundColor: color,
            textColor: Colors.white,
            onPressed: !enabled
                ? () {}
                : () {
              if (canCancel) {
                // cancel dialog -> HA bosilganda CancelOrderBloc ga event
                _showCancelDialog(context, widget.order.id);
              } else if (isStarted && staffCompleted) {
                // confirm completion
                context.read<ConfirmCompletionBloc>().add(
                  ConfirmCompletionE(id: widget.order.id),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Bekor qilasizmi?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Yo‘q")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CancelOrderBloc>().add(
                CancelOrderE(id: id, reason: "Customer canceled"),
              );
            },
            child: const Text("Ha"),
          ),
        ],
      ),
    );
  }
}

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

