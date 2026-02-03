import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_state.dart';

import '../../../worker_home/presentation/pages/worker_profile_image_view.dart';

class HomeAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const
  HomeAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<HomeAppBarWidget> createState() => _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends State<HomeAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: BlocBuilder<CustomerProfileBloc, CustomerProfileState>(
        builder: (context, state) {
          if (state is CustomerProfileLoading) {
          }

          if (state is CustomerProfileError) {
            return const Text(
              "Xatolik",
              style: TextStyle(color: Colors.black),
            );
          }

          if (state is CustomerProfileSuccess) {
            final profile = state.customerProfileEntity;

            final imageUrl = profile.image.isNotEmpty
                ? (profile.image.startsWith('http')
                ? profile.image
                : 'https://tezxizmatlar.uz${profile.image}')
                : null;

            return Row(
              children: [
                GestureDetector(
                  onTap: imageUrl == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => WorkerProfileImageView(
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: profileHeroTag,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: imageUrl != null
                          ? NetworkImage(imageUrl)
                          : const AssetImage('assets/profile/per.png') as ImageProvider,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    "${profile.firstName} ${profile.lastName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          }
          return const Text("");
        },
      ),
      actions: [
        IconButton(onPressed:(){
          Navigator.pushNamed(context, RouteNames.search);
        }, icon: SvgPicture.asset("assets/home/search.svg")),
        SizedBox(width: 10.w),
        IconButton(onPressed:(){

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Ushbu xizmat hali mavjud emas!"),
                duration: Duration(seconds: 3),
              ));

          // Navigator.pushNamed(context, RouteNames.notification);
        }, icon: SvgPicture.asset("assets/home/notification.svg")),
        SizedBox(width: 15.w),
      ],
    );
  }
}