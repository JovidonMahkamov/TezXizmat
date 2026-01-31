import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_state.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_home_event.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_app_bar_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_carousel_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_circular_avatar_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_container_widget.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_event.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // UI ochilishi bilan API chaqiriladi
    context.read<CustomerGetAllStaffBloc>().add(CustomerGetAllStaff());
    context.read<CustomerProfileBloc>().add(CustomerProfileE());
  }

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _reload() async {
    final ok = await _hasInternet();
    if (!mounted) return;

    if (ok) {
      context.read<CustomerGetAllStaffBloc>().add(const CustomerGetAllStaff());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Internet mavjud emas!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              HomeCarouselWidget(),
              SizedBox(height: 15.h),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Xizmatlar",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HomeCircularAvatarWidget(
                            iconAvatar: SvgPicture.asset(
                              "assets/circular_avatar/elektirik.svg",
                            ),
                            circularColor: Color(0xffF0FAF2),
                            title: 'Elektrik',
                          ),
                          SizedBox(width: 18.w),
                          HomeCircularAvatarWidget(
                            iconAvatar: SvgPicture.asset(
                              "assets/circular_avatar/santexnik.svg",
                            ),
                            circularColor: Color(0xffE5F3FB),
                            title: 'Santexnik',
                          ),
                          SizedBox(width: 18.w),
                          HomeCircularAvatarWidget(
                            iconAvatar: SvgPicture.asset(
                              "assets/circular_avatar/culler.svg",
                            ),
                            circularColor: Color(0xffF4EAFB),
                            title: 'Konditsioner ustasi',
                          ),
                          SizedBox(width: 18.w),
                          HomeCircularAvatarWidget(
                            iconAvatar: SvgPicture.asset(
                              "assets/circular_avatar/cleaner.svg",
                            ),
                            circularColor: Color(0xffFFE5EA),
                            title: 'Uy tozalovchi',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "Ishchilar ro'yxati",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    BlocBuilder<CustomerGetAllStaffBloc, CustomerGetAllStaffState>(
                      builder: (context, state) {
                        if (state is CustomerGetAllStaffLoading) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffF2F2F2),
                                  highlightColor: Color(0xffFBFBFB),
                                  child: Container(
                                    height: 90,
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

                        if (state is CustomerGetAllStaffError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(state.message, textAlign: TextAlign.center),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed:
                                    _reload,
                                    child: const Text("Qayta urinish"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is CustomerGetAllStaffSuccess) {
                          final staffList = state.customerGetAllStaffEntity; //  List

                          if (staffList.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text("Hozircha ishchilar topilmadi"),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: staffList.length,
                              itemBuilder: (context, index) {
                                final staff = staffList[index];

                                debugPrint("staff.image(raw) = '${staff.image}'");
                                final raw0 = staff.image?.trim();
                                final raw = (raw0 == null || raw0.isEmpty || raw0 == 'null') ? null : raw0;

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
                                return HomeContainerWidget(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.workerInfo,
                                      arguments: staff.id,
                                    );
                                  },
                                  circularImage: imageUrl != null
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage("assets/circular_avatar/profile.png") as ImageProvider,

                                  nameText: "${staff.first_name} ${staff.last_name}",
                                  profession: staff.profession,
                                );
                              },
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),



                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
