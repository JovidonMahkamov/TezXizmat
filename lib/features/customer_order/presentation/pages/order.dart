import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';

import 'package:tez_xizmat/features/customer_chat/presentation/bloc/find_chat/find_chat_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/find_chat/find_chat_state.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';

import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_state.dart';

import 'package:tez_xizmat/features/customer_order/presentation/bloc/delete_order/delete_order_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/delete_order/delete_order_state.dart';

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

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _pendingChatArgs;

  late final TabController _tabController;
  int _tabIndex = 0; // 0=Faol, 1=Yakunlangan, 2=Bekor qilingan

  bool isSelectionMode = false;
  final Set<int> selectedIndexes = {};
  List<GetAllOrdersEntity> _canceledCache = [];
  Timer? _pollTimer;
  bool _loadingDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabIndex != _tabController.index) {
        setState(() {
          _tabIndex = _tabController.index;

          if (_tabIndex != 2) {
            isSelectionMode = false;
            selectedIndexes.clear();
          }
        });
      }
    }

    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reload();
      context.read<CustomerGetAllStaffBloc>().add(CustomerGetAllStaff());
      context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE(silent: true));

    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();

    _pollTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted) return;
      if (isSelectionMode) return;

      context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE(silent: true));
    });
  }


  void toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
      if (selectedIndexes.isEmpty) isSelectionMode = false;
    });
  }

  void _showLoading() {
    if (_loadingDialogOpen) return;
    _loadingDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoading() {
    if (!_loadingDialogOpen) return;
    _loadingDialogOpen = false;
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  void _clearSelection() {
    setState(() {
      selectedIndexes.clear();
      isSelectionMode = false;
    });
  }

  Future<void> _reload() async {
    context.read<GetCustomerAllOrdersBloc>().add(const GetCustomerAllOrdersE());
  }

  Future<void> deleteSelectedOrders() async {
    if (_tabIndex != 2) return; // faqat bekor qilingan tab
    if (_canceledCache.isEmpty || selectedIndexes.isEmpty) return;

    final ids = selectedIndexes
        .where((i) => i >= 0 && i < _canceledCache.length)
        .map((i) => _canceledCache[i].id)
        .toList();

    if (ids.isEmpty) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Buyurtmani o‘chirish", style: TextStyle(fontWeight: FontWeight.w500),),
        content: Text("${ids.length} ta bekor qilingan buyurtmani o‘chirmoqchimisiz?", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedWidget(
                  onPressed: () => Navigator.pop(context, false),
                  text: 'Bekor qilish',
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: ElevatedWidget(
                  onPressed: () => Navigator.pop(context, true),
                  text: 'O‘chirish',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                ),
              ),
            ],

          ),
        ],
      ),
    );

    if (ok != true) return;

    // Multi delete event (bloc ichida for bilan birma-bir delete)
    context.read<DeleteOrderBloc>().add(DeleteOrdersE(ids: ids));
  }

  // ====== STATUS HELPERS (seniki) ======
  bool _isCanceled(String s) {
    final up = s.toUpperCase();
    return up == 'CANCELED' || up == 'CANCELLED';
  }

  bool _isFinalCompleted(String s) {
    final up = s.toUpperCase();
    return up == 'COMPLETED' ||
        up == 'COMPLETED_BY_CUSTOMER' ||
        up == 'CONFIRMED_BY_CUSTOMER' ||
        up == 'CONFIRMED';
  }


  bool _needsCustomerConfirm(String s) => s.toUpperCase() == 'COMPLETED_BY_STAFF';

  List<GetAllOrdersEntity> _active(List<GetAllOrdersEntity> all) {
    return all.where((o) => !_isFinalCompleted(o.status) && !_isCanceled(o.status)).toList();
  }

  List<GetAllOrdersEntity> _completed(List<GetAllOrdersEntity> all) {
    return all.where((o) => _isFinalCompleted(o.status)).toList();
  }

  List<GetAllOrdersEntity> _canceled(List<GetAllOrdersEntity> all) {
    return all.where((o) => _isCanceled(o.status)).toList();
  }

  String _formatDt(DateTime dt) {
    final local = dt.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return "$hh:$mm";
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
        return Colors.purple;
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
    return MultiBlocListener(
      listeners: [
        BlocListener<FindChatBloc, FindChatState>(
          listener: (context, state) {
            if (state is FindChatSuccess) {
              final args = _pendingChatArgs ?? {};
              Navigator.pushNamed(
                context,
                RouteNames.chatWithWorker,
                arguments: {
                  "roomId": state.findChatEntity.id,
                  "name": args["name"] ?? "",
                  "imageUrl": args["imageUrl"],
                },
              );
            }
            if (state is FindChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
        ),

        BlocListener<DeleteOrderBloc, DeleteOrderState>(
          listener: (context, state) {
            if (state is DeleteOrderLoading) _showLoading();

            if (state is DeleteOrderSuccess) {
              _hideLoading();
              _clearSelection();
              _reload();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Bekor qilingan buyurtma(lar) o‘chirildi")),
              );
            }

            if (state is DeleteOrderError) {
              _hideLoading();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Buyurtmalar",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(onPressed:(){

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Ushbu xizmat hali mavjud emas!"),
                      duration: Duration(seconds: 3),
                    ));
              },

                  icon: SvgPicture.asset("assets/home/delete.svg")),
            ),
            // if (_tabIndex == 2)
            //   Padding(
            //     padding: const EdgeInsets.only(right: 20),
            //     child: IconButton(
            //       onPressed: () {
            //         if (!isSelectionMode) {
            //           setState(() => isSelectionMode = true);
            //           return;
            //         }
            //
            //         if (selectedIndexes.isEmpty) {
            //           _clearSelection(); // cancel selection
            //         } else {
            //           deleteSelectedOrders(); // delete
            //         }
            //       },
            //       icon: SvgPicture.asset(
            //         "assets/home/delete.svg",
            //         width: 30,
            //         height: 30,
            //         colorFilter: ColorFilter.mode(
            //           isSelectionMode ? Colors.red : Colors.black,
            //           BlendMode.srcIn,
            //         ),
            //       ),
            //       tooltip: !isSelectionMode
            //           ? "Tanlash"
            //           : (selectedIndexes.isEmpty ? "Bekor qilish" : "O‘chirish"),
            //     ),
            //   ),
          ],



        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.blueAccent,
                    tabAlignment: TabAlignment.center,
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: const Color(0xffB8BFE1),
                    labelStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
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
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
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

                        _canceledCache = canceled;

                        final staffState = context.watch<CustomerGetAllStaffBloc>().state;
                        final staffMap = <int, dynamic>{};

                        if (staffState is CustomerGetAllStaffSuccess) {
                          for (final s in staffState.customerGetAllStaffEntity) {
                            staffMap[s.id] = s;
                          }
                        }

                        Widget buildList(
                            List<GetAllOrdersEntity> list, {
                              required bool withActions,
                              required bool isCanceledTab,
                              bool withChat = true,
                            }) {
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
                                final staff = staffMap[o.staff.id];

                                final name = staff != null
                                    ? "${staff.first_name} ${staff.last_name}"
                                    : "Usta #${o.staff.id}";

                                final raw0 = o.staff.image.trim();
                                final raw = (raw0.isEmpty || raw0 == 'null') ? null : raw0;

                                String? imageUrl;
                                if (raw != null) {
                                  if (raw.startsWith('http://')) {
                                    imageUrl = raw.replaceFirst('http://', 'https://');
                                  } else if (raw.startsWith('https://')) {
                                    imageUrl = raw;
                                  } else {
                                    imageUrl = 'https://tezxizmatlar.uz${raw.startsWith('/') ? '' : '/'}$raw';
                                  }
                                }

                                final time = _formatDt(o.createdAt);

                                final widgetCard = withActions
                                    ? OrderContainerWidget(
                                  heroTag: "order-avatar-${o.id}",
                                  name: name,
                                  description: o.problemText,
                                  time: time,
                                  statusText: _statusText(o.status),
                                  statusColor: _statusColor(o.status),
                                  imageUrl: imageUrl,
                                  onViewTap: () async {
                                    await Navigator.pushNamed(context, RouteNames.orderView, arguments: o);
                                    _reload();
                                  },
                                  onChatTap: withChat
                                      ? () {
                                    _pendingChatArgs = {"name": name, "imageUrl": imageUrl};
                                    context.read<FindChatBloc>().add(
                                      FindChatCustomerE(
                                        staffId: o.staff.id,
                                        orderId: o.id,
                                      ),
                                    );
                                  }
                                      : null,
                                )
                                    : OrderContainerWidgetTwo(
                                  heroTag: "order-avatar-${o.id}",
                                  name: name,
                                  description: o.problemText,
                                  time: time,
                                  statusText: _statusText(o.status),
                                  statusColor: _statusColor(o.status),
                                  imageUrl: imageUrl,
                                );

                                if (!isCanceledTab) return widgetCard;

                                final isSelected = selectedIndexes.contains(index);

                                return InkWell(
                                  onLongPress: () {
                                    setState(() {
                                      isSelectionMode = true;
                                      selectedIndexes.add(index);
                                    });
                                  },
                                  onTap: () {
                                    if (!isSelectionMode) return;
                                    toggleSelection(index);
                                  },
                                  child: Row(
                                    children: [
                                      if (isSelectionMode)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                                            child: isSelected
                                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                                : null,
                                          ),
                                        ),
                                      Expanded(child: widgetCard),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        return TabBarView(
                          controller: _tabController,
                          children: [
                            buildList(active, withActions: true, isCanceledTab: false),
                            buildList(completed, withActions: true, isCanceledTab: false, withChat: false),
                            buildList(canceled, withActions: false, isCanceledTab: true),
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
      ),
    );
  }
}
