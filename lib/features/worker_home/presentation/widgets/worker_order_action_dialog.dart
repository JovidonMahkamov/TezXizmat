import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/accept_order/accept_order_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/accept_order/accept_order_state.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/complete_by_staff_order/complete_by_staff_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/complete_by_staff_order/complete_by_staff_state.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/start_order/start_order_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/start_order/start_order_state.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/worker_home_event.dart';

Future<void> showWorkerOrderActionSheet(
  BuildContext context,
  PutOrdersStateEntity o,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _WorkerOrderActionSheet(order: o),
  );
}

class _WorkerOrderActionSheet extends StatelessWidget {
  final PutOrdersStateEntity order;

  const _WorkerOrderActionSheet({required this.order});

  bool get isPending => order.status.toUpperCase() == 'PENDING';

  bool get isAccepted => order.status.toUpperCase() == 'ACCEPTED';

  bool get isInProgress {
    final up = order.status.toUpperCase();
    return up == 'IN_PROGRESS' || up == 'STARTED';
  }

  @override
  Widget build(BuildContext context) {
    final fullName = "${order.customer.firstName} ${order.customer.lastName}"
        .trim();

    return MultiBlocListener(
      listeners: [
        BlocListener<AcceptOrderBloc, AcceptOrderState>(
          listener: (context, state) {
            if (state is AcceptOrderSuccess) Navigator.pop(context);
          },
        ),
        BlocListener<StartOrderBloc, StartOrderState>(
          listener: (context, state) {
            if (state is StartOrderSuccess) Navigator.pop(context);
          },
        ),
        BlocListener<CompleteByStaffBloc, CompleteByStaffState>(
          listener: (context, state) {
            if (state is CompleteByStaffSuccess) Navigator.pop(context);
          },
        ),
      ],
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 14,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(order.problemText, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Text(
              order.address,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 14),
            // ACTION BUTTON
            if (isPending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AcceptOrderBloc>().add(
                      AcceptOrderE(id: order.id),
                    );
                  },
                  child: const Text("Qabul qilish"),
                ),
              )
            else if (isAccepted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<StartOrderBloc>().add(
                      StartOrderE(id: order.id),
                    );
                  },
                  child: const Text("Ishni boshlash"),
                ),
              )
            else if (isInProgress)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CompleteByStaffBloc>().add(
                      CompleteOrderE(id: order.id),
                    );
                  },
                  child: const Text("Ishni tugatdim"),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  child: const Text("Bu buyurtmada amal yo‘q"),
                ),
              ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
