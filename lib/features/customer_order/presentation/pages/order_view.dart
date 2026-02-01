import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/cancel_order/cancel_order_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/cancel_order/cancel_order_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/reject_button_widget.dart';

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
      context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE());
    });
  }
  String get _status => (currentOrder.status).toUpperCase();

  bool get canCancel =>
      (currentOrder.acceptedAt == null || currentOrder.acceptedAt!.isEmpty) &&
          _status == 'PENDING';

  bool get isAccepted =>
      (currentOrder.acceptedAt != null && currentOrder.acceptedAt!.isNotEmpty) ||
          _status == 'ACCEPTED';

  bool get isStarted =>
      (currentOrder.startedAt != null && currentOrder.startedAt!.isNotEmpty) ||
          _status == 'IN_PROGRESS' ||
          _status == 'STARTED';

  bool get staffCompleted =>
      (currentOrder.completedByStaffAt != null &&
          currentOrder.completedByStaffAt!.isNotEmpty);

  bool get customerCompleted =>
      (currentOrder.completedByCustomerAt != null &&
          currentOrder.completedByCustomerAt!.isNotEmpty) ||
          _status == 'COMPLETED';

  String get pageTitle {
    if (isStarted) return "Ish bajarilmoqda";
    if (isAccepted) return "Qabul qilindi";
    return "Ko‘rib chiqilmoqda";
  }

  String get infoText {
    if (isStarted) {
      return "Ish yakunlangach, iltimos “Ish yakunlandi” tugmasini bosing. "
          "Bu orqali buyurtma yopiladi va to‘lov jarayoni boshlanadi.";
    }
    if (isAccepted) {
      return "Buyurtmangiz qabul qilindi. Ijrochi bilan bog‘lanish uchun chatdan foydalanishingiz mumkin.";
    }
    return "Ijrochi hali buyurtmani qabul qilmagan. Javob berishi kutilmoqda...";
  }

  ({String text, bool enabled, Color color}) get buttonConfig {
    if (customerCompleted) {
      return (text: "Yakunlangan", enabled: false, color: Colors.green);
    }

    if (isStarted) {
      // Staff complete qilmaguncha customer confirm qilolmaydi
      final enabled = staffCompleted;
      return (
      text: "Ish yakunlandi",
      enabled: enabled,
      color: enabled ? Colors.green : Colors.green.shade200
      );
    }

    if (isAccepted) {
      return (
      text: "Jarayon bekor qilib bo‘lmaydi",
      enabled: false,
      color: Colors.orange.shade200
      );
    }

    return (text: "Jarayonni bekor qilish", enabled: canCancel, color: Colors.red);
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
            if (state is ConfirmCompletionSuccess) {
              _reload();

              // TODO: rating bottomsheet (keyin ulaysan)
              // showModalBottomSheet(...);
            }
          },
        ),
      ],
      child: BlocBuilder<GetCustomerAllOrdersBloc, GetCustomerAllOrdersState>(
        builder: (context, state) {
          // ✅ eng muhim joy: bloc’dan kelgan listdan currentOrder yangilansin
          if (state is GetCustomerAllOrdersSuccess) {
            final list = state.getAllOrdersEntity;
            final idx = list.indexWhere((e) => e.id == widget.order.id);
            if (idx != -1) {
              currentOrder = list[idx];
            }
          }
          final cfg = buttonConfig;
          return Scaffold(
            appBar: AppBar(
              title: Text(pageTitle),
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
              padding: const EdgeInsets.all(20),
              child: RejectButtonWidget(
                text: cfg.text,
                backgroundColor: cfg.color,
                textColor: Colors.white,
                //  disabled bo‘lishi uchun null
                onPressed: cfg.enabled
                    ? () {
                  if (canCancel) {
                    _showCancelDialog(context, currentOrder.id);
                  } else if (isStarted && staffCompleted) {
                    context.read<ConfirmCompletionBloc>().add(
                      ConfirmCompletionE(id: currentOrder.id),
                    );
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
        title: const Text("Bekor qilasizmi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yo‘q"),
          ),
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, height: 1.35),
      ),
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
          Text(
            "Buyurtma #${order.id}",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _row("Manzil", order.address),
          const SizedBox(height: 6),
          _row("Muammo", order.problemText),
          const SizedBox(height: 6),
          _row("Holat", order.status),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            "$label:",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
