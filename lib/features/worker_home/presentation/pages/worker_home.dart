import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_carousel_widget.dart';
import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/get_staff_orders/get_staff_orders_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/get_staff_orders/get_staff_orders_state.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/worker_home_event.dart';
import 'package:tez_xizmat/features/worker_home/presentation/widgets/home_worker_app_bar_widget.dart';
import 'package:tez_xizmat/features/worker_home/presentation/widgets/order_widget.dart';
import 'package:tez_xizmat/features/worker_home/presentation/widgets/order_widget_two.dart';
import 'package:tez_xizmat/features/worker_home/presentation/widgets/worker_order_action_dialog.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';




class WorkerHomePage extends StatefulWidget {

  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetStaffOrdersBloc>().add( GetStaffOrdersE());
    });
    context.read<WorkerProfileBloc>().add(WorkerProfileE());
  }

  Future<void> _reload() async {
    context.read<GetStaffOrdersBloc>().add(const GetStaffOrdersE());
  }

  bool _isCompleted(String s) {
    final up = s.toUpperCase();
    return up == 'COMPLETED' || up == 'DONE' || up == 'FINISHED';
  }

  bool _isCanceled(String s) {
    final up = s.toUpperCase();
    return up == 'CANCELED' || up == 'CANCELLED';
  }

  bool _isStarted(String status) {
    final up = status.toUpperCase();
    return up == 'IN_PROGRESS' || up == 'STARTED';
  }


  List<PutOrdersStateEntity> _active(List<PutOrdersStateEntity> all) {
    return all.where((o) => !_isCompleted(o.status) && !_isCanceled(o.status)).toList();
  }

  List<PutOrdersStateEntity> _completed(List<PutOrdersStateEntity> all) {
    return all.where((o) => _isCompleted(o.status)).toList();
  }

  List<PutOrdersStateEntity> _canceled(List<PutOrdersStateEntity> all) {
    return all.where((o) => _isCanceled(o.status)).toList();
  }

  List<PutOrdersStateEntity> _startedOrders(
      List<PutOrdersStateEntity> all,
      ) {
    return all.where((o) => _isStarted(o.status)).toList();
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
        return "Hali qabul qilmagansiz";
      case 'ACCEPTED':
        return "Qabul qildingiz";
      case 'IN_PROGRESS':
        return "Jarayonda";
      case 'COMPLETED':
        return "Ish muvaffaqiyatli yakunlangan";
      case 'CANCELED':
      case 'CANCELLED':
        return "Ishni bekor qilgansiz";
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

  Widget _buildActive(List<PutOrdersStateEntity> list) {
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

          return OrderWidget(
            // Worker tarafda bu “customer_name” bo‘lishi kerak,
            // lekin entityda yo‘q bo‘lsa title chiqib qoladi.
            // Agar API customer_name qaytarsa entityga ham qo‘shib olamiz.
            name: o.customer.firstName, // vaqtinchalik
            description: o.problemText,
            time: _formatTime(o.createdAt),
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
            onViewTap: () async{
              await showWorkerOrderActionSheet(context, o);
              _reload();
              // agar orderni dialogga uzatmoqchi bo‘lsang:
              // customerShowInfoWidget(context, order: o);
            },
            onChatTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.chatWithWorker,
                arguments: {
                  "name": "Mijoz",
                  "urlAsset": "assets/circular_avatar/profile.png",
                },
              );
            },
          );
        },
      ),
    );
  }
  Widget _buildCompleted(List<PutOrdersStateEntity> list) {
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
          return OrderWidgetTwo(
            name: o.customer.firstName,
            description: o.problemText,
            time: _formatTime(o.completedByStaffAt),
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
          );
        },
      ),
    );
  }
  Widget _buildCanceled(List<PutOrdersStateEntity> list) {
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
          return OrderWidgetTwo(
            name: o.customer.firstName,
            description: o.problemText,
            time: _formatTime(o.canceledAt),
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
          );
        },
      ),
    );
  }
  Widget _buildStarted(List<PutOrdersStateEntity> list) {
    if (list.isEmpty) return _empty("");

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 23.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final o = list[index];
          return OrderWidgetTwo(
            name: o.customer.firstName,
            description: o.problemText,
            time: _formatTime(o.canceledAt),
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
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
                          unselectedLabelColor: const Color(0xffB8BFE1),
                          labelStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                          tabs: const [
                            Tab(child: Text("Faol", style: TextStyle(fontWeight: FontWeight.w700))),
                            Tab(child: Text("Yakunlangan", style: TextStyle(fontWeight: FontWeight.w700))),
                            Tab(child: Text("Bekor qilingan", style: TextStyle(fontWeight: FontWeight.w700))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<GetStaffOrdersBloc, GetStaffOrdersState>(
                          builder: (context, state) {
                            if (state is GetStaffOrdersLoading) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12, top: 20),
                                    child: Shimmer.fromColors(
                                      baseColor: Color(0xffF2F2F2),
                                      highlightColor: Color(0xffFBFBFB),
                                      child: Container(
                                        height: 240,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            // Avatar shimmer
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 12),

                                            // Text shimmer
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 14,
                                                    width: double.infinity,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    height: 12,
                                                    width: 120,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            if (state is GetStaffOrdersError) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(state.message, textAlign: TextAlign.center),
                                    SizedBox(height: 12.h),
                                    ElevatedButton(
                                      onPressed: _reload,
                                      child: const Text("Qayta urinish"),
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (state is GetStaffOrdersSuccess) {
                              final all = state.putOrdersStateEntity; // <- sendeda list nomi shunaqa bo‘lishi kerak
                              final active = _active(all);
                              final started = _startedOrders(all);
                              final completed = _completed(all);
                              final canceled = _canceled(all);

                              return TabBarView(
                                children: [
                                  _buildActive(active),
                                  _buildCompleted(completed),
                                  _buildCanceled(canceled),
                                ],
                              );
                            }

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
            ],
          ),
        ),
      ),
    );
  }
}
