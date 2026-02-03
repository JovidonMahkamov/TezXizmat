import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_state.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_state.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_home_event.dart';
import '../../../../core/routes/route_names.dart';
import '../widgets/order_Container_widget.dart';
import '../widgets/order_Container_widgetTwo.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reload();
      context.read<CustomerGetAllStaffBloc>().add(CustomerGetAllStaff());
    });
  }

  // ---------- Helpers ----------
  String? _normalizeImage(String? raw) {
    if (raw == null) return null;
    final v = raw.trim();
    if (v.isEmpty || v == 'null') return null;

    if (v.startsWith('http://')) return v.replaceFirst('http://', 'https://');
    if (v.startsWith('https://')) return v;
    return 'https://tezxizmatlar.uz${v.startsWith('/') ? '' : '/'}$v';
  }

  bool _isCanceled(String s) {
    final up = s.toUpperCase();
    return up == 'CANCELED' || up == 'CANCELLED';
  }

  ///  Final yakunlangan (customer tasdiqlaganidan keyin)
  bool _isFinalCompleted(String s) {
    final up = s.toUpperCase();
    return up == 'COMPLETED' ||
        up == 'COMPLETED_BY_CUSTOMER' ||
        up == 'CONFIRMED_BY_CUSTOMER' ||
        up == 'CONFIRMED';
  }

  ///  Staff yakunlagan, customer tasdiqlashi kerak
  bool _needsCustomerConfirm(String s) => s.toUpperCase() == 'COMPLETED_BY_STAFF';

  List<GetAllOrdersEntity> _active(List<GetAllOrdersEntity> all) {
    // Active = Canceled ham emas, Final completed ham emas
    //  COMPLETED_BY_STAFF ham shu yerga tushadi
    return all.where((o) => !_isFinalCompleted(o.status) && !_isCanceled(o.status)).toList();
  }

  List<GetAllOrdersEntity> _completed(List<GetAllOrdersEntity> all) {
    return all.where((o) => _isFinalCompleted(o.status)).toList();
  }

  List<GetAllOrdersEntity> _canceled(List<GetAllOrdersEntity> all) {
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
    final up = status.toUpperCase();
    switch (up) {
      case 'PENDING':
        return "Yuborildi";
      case 'ACCEPTED':
        return "Qabul qilindi";
      case 'IN_PROGRESS':
      case 'STARTED':
        return "Jarayonda";
      case 'COMPLETED_BY_STAFF':
        return "Tasdiqlash kutilmoqda";
      case 'COMPLETED':
      case 'COMPLETED_BY_CUSTOMER':
      case 'CONFIRMED_BY_CUSTOMER':
      case 'CONFIRMED':
        return "Yakunlangan";
      case 'CANCELED':
      case 'CANCELLED':
        return "Bekor qilindi";
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    final up = status.toUpperCase();
    switch (up) {
      case 'PENDING':
        return Colors.orange;
      case 'ACCEPTED':
      case 'IN_PROGRESS':
      case 'STARTED':
        return Colors.blueAccent;
      case 'COMPLETED_BY_STAFF':
        return Colors.purple; // ko‘zga ajralib tursin
      case 'COMPLETED':
      case 'COMPLETED_BY_CUSTOMER':
      case 'CONFIRMED_BY_CUSTOMER':
      case 'CONFIRMED':
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
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12, top: 20),
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xffF2F2F2),
                                highlightColor: const Color(0xffFBFBFB),
                                child: Container(
                                  height: 180,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(width: 56, height: 56, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(height: 14, width: double.infinity, color: Colors.white),
                                            const SizedBox(height: 8),
                                            Container(height: 12, width: 120, color: Colors.white),
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

                      if (state is GetCustomerAllOrdersError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(state.message, textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp)),
                                SizedBox(height: 12.h),
                                ElevatedButton(onPressed: _reload, child: const Text("Qayta urinish")),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is GetCustomerAllOrdersSuccess) {
                        final all = state.getAllOrdersEntity;
                        final active = _active(all);
                        final completed = _completed(all);
                        final canceled = _canceled(all);

                        final staffState = context.watch<CustomerGetAllStaffBloc>().state;
                        final staffMap = <int, dynamic>{};

                        if (staffState is CustomerGetAllStaffSuccess) {
                          for (final s in staffState.customerGetAllStaffEntity) {
                            staffMap[s.id] = s;
                          }
                        }

                        Widget buildList(List<GetAllOrdersEntity> list, {required bool withActions}) {
                          if (list.isEmpty) return _empty("Hozircha buyurtmalar yo‘q.");

                          return RefreshIndicator(
                            onRefresh: _reload,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 10.h),
                              itemCount: list.length,
                              separatorBuilder: (_, __) => SizedBox(height: 10.h),
                              itemBuilder: (context, index) {
                                final o = list[index];
                                final staff = staffMap[o.staffId];

                                final name = staff != null
                                    ? "${staff.first_name} ${staff.last_name} (${(staff.profession as String).isEmpty ? 'Usta' : staff.profession})"
                                    : "Usta #${o.staffId}";

                                final imageUrl = staff != null ? _normalizeImage(staff.image as String?) : null;
                                final time = _formatTime(o.createdAt);

                                if (withActions) {
                                  return OrderContainerWidget(
                                    name: name,
                                    description: o.problemText,
                                    time: time,
                                    statusText: _statusText(o.status),
                                    statusColor: _statusColor(o.status),
                                    imageUrl: imageUrl,
                                    onViewTap: () async {
                                      await Navigator.pushNamed(context, RouteNames.orderView, arguments: o);
                                      _reload(); //  qaytganda refresh
                                    },
                                    onChatTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.chatWithWorker,
                                        arguments: {
                                          "name": name,
                                          "urlAsset": imageUrl ?? "assets/circular_avatar/profile.png",
                                          "roomId": o.id,
                                        },
                                      );
                                    },
                                  );
                                }

                                return OrderContainerWidgetTwo(
                                  name: name,
                                  description: o.problemText,
                                  time: time,
                                  statusText: _statusText(o.status),
                                  statusColor: _statusColor(o.status),
                                  imageUrl: imageUrl,
                                );
                              },
                            ),
                          );
                        }

                        return TabBarView(
                          children: [
                            buildList(active, withActions: true),
                            buildList(completed, withActions: true),
                            buildList(canceled, withActions: false),
                          ],
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: _reload,
                        child: ListView(physics: const AlwaysScrollableScrollPhysics(), children: const [SizedBox(height: 200)]),
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