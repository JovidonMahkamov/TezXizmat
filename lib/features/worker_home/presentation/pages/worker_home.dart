import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/find_chat/find_chat_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/find_chat/find_chat_state.dart';
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
import 'package:tez_xizmat/features/customer_order/presentation/bloc/delete_order/delete_order_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/delete_order/delete_order_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? pendingChatArgs;

  //  tab indexni bilish uchun
  late final TabController _tabController;
  int _tabIndex = 0; // 0=Faol,1=Yakunlangan,2=Bekor qilingan

  //  canceled tab selection
  bool isSelectionMode = false;
  final Set<int> selectedIndexes = {};
  List<PutOrdersStateEntity> _canceledCache = [];

  bool _loadingDialogOpen = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabIndex != _tabController.index) {
        setState(() {
          _tabIndex = _tabController.index;

          // canceled tabdan chiqsa selection tozalanadi
          if (_tabIndex != 2) {
            isSelectionMode = false;
            selectedIndexes.clear();
          }
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GetStaffOrdersBloc>().add(const GetStaffOrdersE());
      context.read<WorkerProfileBloc>().add(WorkerProfileE());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final ok = await _hasInternet();
    if (!mounted) return;
    if (ok) {
      context.read<GetStaffOrdersBloc>().add(const GetStaffOrdersE());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Internet mavjud emas!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
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

  Future<void> deleteSelectedOrders() async {
    if (_tabIndex != 2) return; // faqat canceled tab
    if (_canceledCache.isEmpty || selectedIndexes.isEmpty) return;

    final ids = selectedIndexes
        .where((i) => i >= 0 && i < _canceledCache.length)
        .map((i) => _canceledCache[i].id) // PutOrdersStateEntity.id = order_id
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

    //  Multi delete (bloc ichida for bilan birma-bir delete qiladi)
    context.read<DeleteOrderBloc>().add(DeleteOrdersE(ids: ids));
  }

  bool _isCompleted(PutOrdersStateEntity o) {
    final up = o.status.toUpperCase();

    if (up == 'COMPLETED_BY_CUSTOMER' ||
        up == 'CONFIRMED_BY_CUSTOMER' ||
        up == 'CONFIRMED' ||
        up == 'COMPLETED' ||
        up == 'DONE' ||
        up == 'FINISHED') {
      return true;
    }

    if ((o.completedByCustomerAt != null && o.completedByCustomerAt!.isNotEmpty) ||
        (o.completedByStaffAt != null && o.completedByStaffAt!.isNotEmpty)) {
      return true;
    }

    return false;
  }

  bool _isCanceled(PutOrdersStateEntity o) {
    if (o.canceledAt != null && o.canceledAt!.isNotEmpty) return true;
    final up = o.status.toUpperCase();
    return up == 'CANCELED' || up == 'CANCELLED';
  }

  List<PutOrdersStateEntity> _active(List<PutOrdersStateEntity> all) {
    return all.where((o) => !_isCompleted(o) && !_isCanceled(o)).toList();
  }

  List<PutOrdersStateEntity> _completed(List<PutOrdersStateEntity> all) {
    return all.where(_isCompleted).toList();
  }

  List<PutOrdersStateEntity> _canceled(List<PutOrdersStateEntity> all) {
    return all.where(_isCanceled).toList();
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
      case 'COMPLETED_BY_STAFF':
        return "Siz yakunladingiz, mijoz tasdiqlashi kerak";
      case 'COMPLETED_BY_CUSTOMER':
        return "Mijoz tasdiqladi. Yakunlandi";
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
      case 'COMPLETED_BY_CUSTOMER':
        return Colors.green;
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
    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 250.h),
            _empty("Faol buyurtmalar yo‘q."),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final o = list[index];

          final raw0 = o.customer.image.trim();
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

          return OrderWidget(
            name: o.customer.firstName,
            description: o.problemText,
            time: _formatTime(o.createdAt),
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/profile/per.png",
            onViewTap: () async {
              await showWorkerOrderActionSheet(context, o);
              await _reload();
            },
            onChatTap: () {
              pendingChatArgs = {
                "name": o.customer.firstName,
                "imageUrl": imageUrl,
              };

              context.read<FindChatBloc>().add(
                FindChatStaffE(
                  customerId: o.customer.id,
                  orderId: o.id,
                ),
              );
            },
            backgroundImage: imageUrl != null
                ? NetworkImage(imageUrl)
                : const AssetImage("assets/profile/per.png") as ImageProvider,
          );
        },
      ),
    );
  }

  Widget _buildCompleted(List<PutOrdersStateEntity> list) {
    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 250.h),
            _empty("Yakunlangan buyurtmalar yo‘q."),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final o = list[index];
          return OrderWidgetTwo(
            name: o.customer.firstName,
            description: o.problemText,
            time: _formatTime(o.completedByCustomerAt ?? o.completedByStaffAt),
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
          );
        },
      ),
    );
  }

  Widget _buildCanceled(List<PutOrdersStateEntity> list) {
    //  cache update — delete uchun
    _canceledCache = list;

    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 250.h),
            _empty("Bekor qilingan buyurtmalar yo‘q."),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final o = list[index];
          final isSelected = selectedIndexes.contains(index);

          final card = OrderWidgetTwo(
            name: o.customer.firstName,
            description: o.problemText,
            time: _formatTime(o.canceledAt),
            statusText: _statusText(o.status),
            statusColor: _statusColor(o.status),
            imageUrl: "assets/circular_avatar/profile.png",
          );

          // selection UI only for canceled tab
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
                      child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                    ),
                  ),
                Expanded(child: card),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        //  Oldingi FindChat listener — buzilmaydi
        BlocListener<FindChatBloc, FindChatState>(
          listener: (context, state) {
            if (state is FindChatSuccess) {
              final args = pendingChatArgs ?? {};
              Navigator.pushNamed(
                context,
                RouteNames.chatWithCustomer, // worker route
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

        //  DeleteOrder listener
        BlocListener<DeleteOrderBloc, DeleteOrderState>(
          listener: (context, state) async {
            if (state is DeleteOrderLoading) _showLoading();

            if (state is DeleteOrderSuccess) {
              _hideLoading();
              _clearSelection();
              await _reload(); // listni qayta olamiz
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
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,

          //  AppBar: HomeWorkerAppBarWidget saqlanadi, lekin actions qo‘shamiz
          appBar: HomeWorkerAppBarWidget(
            tabIndex: _tabIndex,
            isSelectionMode: isSelectionMode,
            isDeleteEnabled: selectedIndexes.isNotEmpty,
            onEnterSelection: () => setState(() => isSelectionMode = true),
            onDelete: () => deleteSelectedOrders(),
          ),

          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  SliverToBoxAdapter(child: HomeCarouselWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Buyurtmalar",
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarHeaderDelegate(
                      TabBar(
                        controller: _tabController,
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
                  ),
                ];
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: BlocBuilder<GetStaffOrdersBloc, GetStaffOrdersState>(
                  builder: (context, state) {
                    if (state is GetStaffOrdersLoading) {
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 20),
                            child: Shimmer.fromColors(
                              baseColor: const Color(0xffF2F2F2),
                              highlightColor: const Color(0xffFBFBFB),
                              child: Container(
                                height: 240,
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
                                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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

                    if (state is GetStaffOrdersError) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 120.h),
                          Center(
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
                          ),
                        ],
                      );
                    }

                    if (state is GetStaffOrdersSuccess) {
                      final all = state.putOrdersStateEntity;
                      final active = _active(all);
                      final completed = _completed(all);
                      final canceled = _canceled(all);

                      // canceled cache update
                      _canceledCache = canceled;

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _buildActive(active),
                          _buildCompleted(completed),
                          _buildCanceled(canceled),
                        ],
                      );
                    }

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [SizedBox(height: 200.h)],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarHeaderDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarHeaderDelegate oldDelegate) => false;
}
