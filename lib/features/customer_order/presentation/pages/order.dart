import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_customer_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/order_Container_widget.dart';
import 'package:tez_xizmat/features/customer_order/presentation/widgets/order_Container_widgetTwo.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    // Sahifa ochilishi bilan orderlarni olib keladi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE());
    });
  }

  // ---------- Helpers ----------
  bool _isCompleted(String s) {
    final up = s.toUpperCase();
    return up == 'COMPLETED' || up == 'DONE' || up == 'FINISHED';
  }

  bool _isCanceled(String s) {
    final up = s.toUpperCase();
    return up == 'CANCELED' || up == 'CANCELLED';
  }

  List<GetCustomerAllOrdersEntity> _active(List<GetCustomerAllOrdersEntity> all) {
    return all.where((o) => !_isCompleted(o.status) && !_isCanceled(o.status)).toList();
  }

  List<GetCustomerAllOrdersEntity> _completed(List<GetCustomerAllOrdersEntity> all) {
    return all.where((o) => _isCompleted(o.status)).toList();
  }

  List<GetCustomerAllOrdersEntity> _canceled(List<GetCustomerAllOrdersEntity> all) {
    return all.where((o) => _isCanceled(o.status)).toList();
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return "--:--";
    try {
      final dt = DateTime.parse(iso).toLocal();
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');
      return "$hh:$mm";
    } catch (_) {
      return "--:--";
    }
  }

  String _statusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return "Yuborildi";
      case 'ACCEPTED':
        return "Qabul qilindi";
      case 'IN_PROGRESS':
        return "Jarayonda";
      case 'COMPLETED':
        return "Bajarildi";
      case 'CANCELED':
      case 'CANCELLED':
        return "Bekor qilindi";
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'ACCEPTED':
      case 'IN_PROGRESS':
        return Colors.blueAccent;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELED':
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _reload() async {
    context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE());
  }

  Widget _empty(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildActiveList(List<GetCustomerAllOrdersEntity> list) {
    if (list.isEmpty) return _empty("Faol buyurtmalar yo‘q.");
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 23.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final o = list[index];

          final name = (o.staffName.isNotEmpty)
              ? "${o.staffName} (${o.title})"
              : o.title;

          final time = _formatTime(o.createdAt);

          return OrderContainerWidget(
            name: name,
            description: o.description,
            time: time,
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
            onViewTap: () {
              // Hozircha orderView args olmayapti (xohlasang 2-qismni ham qilamiz)
              Navigator.pushNamed(context, RouteNames.orderView);
            },
            onChatTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.chatWithWorker,
                arguments: {
                  "name": o.staffName.isNotEmpty ? o.staffName : "Usta",
                  "urlAsset": "assets/circular_avatar/profile.png",
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCompletedList(List<GetCustomerAllOrdersEntity> list) {
    if (list.isEmpty) return _empty("Yakunlangan buyurtmalar yo‘q.");
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 23.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final o = list[index];

          final name = (o.staffName.isNotEmpty)
              ? "${o.staffName} (${o.title})"
              : o.title;

          final time = _formatTime(o.completedAt ?? o.updatedAt);

          return OrderContainerWidget(
            name: name,
            description: o.description,
            time: time,
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
            onViewTap: () {
              Navigator.pushNamed(context, RouteNames.orderView);
            },
            onChatTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.chatWithWorker,
                arguments: {
                  "name": o.staffName.isNotEmpty ? o.staffName : "Usta",
                  "urlAsset": "assets/circular_avatar/profile.png",
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCanceledList(List<GetCustomerAllOrdersEntity> list) {
    if (list.isEmpty) return _empty("Bekor qilingan buyurtmalar yo‘q.");
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 23.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final o = list[index];

          final name = (o.staffName.isNotEmpty)
              ? "${o.staffName} (${o.title})"
              : o.title;

          final time = _formatTime(o.canceledAt ?? o.updatedAt);

          return OrderContainerWidgetTwo(
            name: name,
            description: o.description,
            time: time,
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
          );
        },
      ),
    );
  }

  // ---------- UI ----------
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
            padding: EdgeInsets.all(20.sp),
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
                    unselectedLabelColor: const Color(0xffB8BFE1),
                    labelStyle: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text("Faol", style: TextStyle(fontWeight: FontWeight.w700)))),
                      Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text("Yakunlangan", style: TextStyle(fontWeight: FontWeight.w700)))),
                      Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text("Bekor qilingan", style: TextStyle(fontWeight: FontWeight.w700)))),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<GetCustomerAllOrdersBloc, GetCustomerAllOrdersState>(
                    builder: (context, state) {
                      if (state is GetCustomerAllOrdersLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is GetCustomerAllOrdersError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(height: 12.h),
                                ElevatedButton(
                                  onPressed: _reload,
                                  child: const Text("Qayta urinish"),
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is GetCustomerAllOrdersSuccess) {
                        final all = state.getCustomerAllOrdersEntity;
                        final active = _active(all);
                        final completed = _completed(all);
                        final canceled = _canceled(all);

                        return TabBarView(
                          children: [
                            _buildActiveList(active),
                            _buildCompletedList(completed),
                            _buildCanceledList(canceled),
                          ],
                        );
                      }

                      // Initial holatda ham refresh bilan bo‘sh ko‘rsatamiz
                      return RefreshIndicator(
                        onRefresh: _reload,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [SizedBox(height: 200)],
                        ),
                      );
                    },
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
