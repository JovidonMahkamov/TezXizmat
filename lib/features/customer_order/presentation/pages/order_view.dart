import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';

import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/cancel_order/cancel_order_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/cancel_order/cancel_order_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/post_reviews/post_reviews_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/reject_button_widget.dart';

import '../widgets/post_rating_dialog_widget.dart';

class OrderViewPage extends StatefulWidget {
  final GetAllOrdersEntity order;
  const OrderViewPage({super.key, required this.order});

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  late GetAllOrdersEntity currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reload();
    });
  }

  void _showRatingDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ConfirmCompletionBloc>()),
            BlocProvider.value(value: context.read<PostReviewsBloc>()),
          ],
          child: PostRatingDialogWidget(
            orderId: orderId,
            pageContext: context,
          ),
        );
      },
    );
  }



  String get _status => currentOrder.status.toUpperCase();

  bool get isCanceled => _status == 'CANCELED' || _status == 'CANCELLED';

  bool get isPending => _status == 'PENDING';

  bool get isAccepted =>
      _status == 'ACCEPTED' ||
          (currentOrder.acceptedAt != null && currentOrder.acceptedAt!.isNotEmpty);

  bool get isStarted =>
      _status == 'IN_PROGRESS' ||
          _status == 'STARTED' ||
          (currentOrder.startedAt != null && currentOrder.startedAt!.isNotEmpty);

  bool get isCompletedByStaff => _status == 'COMPLETED_BY_STAFF';

  bool get customerCompleted =>
      _status == 'COMPLETED' ||
          _status == 'COMPLETED_BY_CUSTOMER' ||
          _status == 'CONFIRMED_BY_CUSTOMER' ||
          _status == 'CONFIRMED' ||
          (currentOrder.completedByCustomerAt != null && currentOrder.completedByCustomerAt!.isNotEmpty);

  bool get canCancel => isPending && !isCanceled;

  /// ✅ Staff complete bo‘lsa customer confirm bosishi kerak
  bool get canConfirmCompletion => isCompletedByStaff && !customerCompleted && !isCanceled;

  String get pageTitle {
    if (customerCompleted) return "Yakunlangan";
    if (isCanceled) return "Bekor qilingan";

    // ✅ COMPLETED_BY_STAFF ham shu yerga kiradi
    if (isCompletedByStaff || isStarted) return "Ish bajarilmoqda";

    if (isAccepted) return "Qabul qilindi";
    return "Ko‘rib chiqilmoqda";
  }

  String get infoText {
    if (customerCompleted) {
      return "Buyurtma yakunlandi ✅";
    }
    if (isCanceled) {
      return "Buyurtma bekor qilingan ❌";
    }

    if (isCompletedByStaff) {
      return "Ijrochi ishni yakunladi. Buyurtmani yopish uchun pastdagi “Ish yakunlandi” tugmasini bosing.";
    }

    if (isStarted) {
      return "Ish bajarilmoqda. Ijrochi ishni tugatgach, buyurtma sizga tasdiqlash uchun keladi.";
    }

    if (isAccepted) {
      return "Buyurtmangiz qabul qilindi. Ijrochi bilan bog‘lanish uchun chatdan foydalanishingiz mumkin.";
    }

    return "Ijrochi hali buyurtmani qabul qilmagan. Javob berishi kutilmoqda...";
  }

  ({String text, bool enabled, Color color}) get buttonConfig {
    if (customerCompleted) {
      return (text: "Yakunlangan", enabled: false, color: Colors.green.shade400,);
    }
    if (isCanceled) {
      return (text: "Bekor qilingan", enabled: false, color: Colors.red.shade200);
    }

    // ✅ Asosiy fix: COMPLETED_BY_STAFF bo‘lsa confirm tugmasi ishlasin
    if (canConfirmCompletion) {
      return (text: "Ish yakunlandi", enabled: true, color: Colors.purple);
    }

    // pending paytida cancel mumkin
    if (canCancel) {
      return (text: "Jarayonni bekor qilish", enabled: true, color: Colors.red);
    }

    if (isAccepted) {
      return (text: "Qabul qilingan", enabled: false, color: Colors.blue.shade400);
    }

    // qolgan holatlar: cancel ham, confirm ham yo‘q
    return (text: "Jarayon davom etmoqda", enabled: false, color: Colors.orange.shade400);
  }

  Future<void> _reload() async {
    context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CancelOrderBloc, CancelOrderState>(
          listener: (context, state) {
            if (state is CancelOrderSuccess) {
              _reload();
              Navigator.pop(context);
            }
          },
        ),
        BlocListener<ConfirmCompletionBloc, ConfirmCompletionState>(
          listener: (context, state) {
            if (state is ConfirmCompletionLoading) {
              // xohlasang loader qo‘shamiz
            }
            if (state is ConfirmCompletionSuccess) {
              _reload();
            }

            if (state is ConfirmCompletionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetCustomerAllOrdersBloc, GetCustomerAllOrdersState>(
        builder: (context, state) {
          // ✅ listdan kelgan order bilan currentOrder yangilansin
          if (state is GetCustomerAllOrdersSuccess) {
            final list = state.getAllOrdersEntity;
            final idx = list.indexWhere((e) => e.id == widget.order.id);
            if (idx != -1) currentOrder = list[idx];
          }

          final cfg = buttonConfig;

          return Scaffold(
            appBar: AppBar(
              title: Text(pageTitle, style: TextStyle(fontWeight: FontWeight.w500),),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: _reload,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoCard(text: infoText),
                    const SizedBox(height: 12),
                    _OrderCard(order: currentOrder),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 150, left: 20, right: 20),
              child: RejectButtonWidget(
                text: cfg.text,
                backgroundColor: cfg.color,
                textColor: Colors.white,
                onPressed: cfg.enabled
                    ? () {
                  if (canCancel) {
                    _showCancelDialog(context, currentOrder.id);
                  }else if (canConfirmCompletion) {
                    _showRatingDialog(context, currentOrder.id);
                  }
                }
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Bekor qilasizmi?"),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedWidget(
                  onPressed: () => Navigator.pop(context),
                  text: 'Yo‘q',
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(width: 10.w,),
              Expanded(
                child: ElevatedWidget(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<CancelOrderBloc>().add(
                      CancelOrderE(id: id, reason: "Customer canceled"),
                    );
                  },
                  text: 'Ha',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

// ====== UI widgets ======

class _InfoCard extends StatelessWidget {
  final String text;
  const _InfoCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, height: 1.35)),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final GetAllOrdersEntity order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Buyurtma soni: ${order.id}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _row("Manzil", order.address),
          const SizedBox(height: 6),
          _row("Muammo", order.problemText),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text("$label:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }
}
