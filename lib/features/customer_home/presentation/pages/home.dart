import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_state.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_home_event.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_app_bar_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_carousel_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_circular_avatar_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_container_widget.dart';

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(),
      body: SingleChildScrollView(
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
                    "Yaqin atrofingizdagi ishchilar",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  BlocBuilder<CustomerGetAllStaffBloc, CustomerGetAllStaffState>(
                    builder: (context, state) {
                      if (state is CustomerGetAllStaffLoading) {
                        return const Center(child: CircularProgressIndicator());
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
                                  onPressed: () {
                                    context.read<CustomerGetAllStaffBloc>().add(CustomerGetAllStaff());
                                  },
                                  child: const Text("Qayta urinish"),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is CustomerGetAllStaffSuccess) {
                        final staffList = state.customerGetAllStaffEntity; // ✅ List

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

                              final raw = staff.image; // String? bo‘lishi kerak
                              final imageUrl = (raw != null && raw.trim().isNotEmpty)
                                  ? (raw.startsWith('http') ? raw : 'https://tezxizmatlar.uz$raw')
                                  : null;


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
                                    : const AssetImage("assets/circular_avatar/profile.png")
                                as ImageProvider,
                                nameText: "${staff.first_name} (${staff.profession})",
                                experienceText: staff.price,
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
    );
  }
}
