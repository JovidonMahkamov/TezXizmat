import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/worker_home/presentation/pages/worker_profile_image_view.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_state.dart';

class HomeWorkerAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final int tabIndex;
  final bool isSelectionMode;
  final bool isDeleteEnabled;

  final VoidCallback? onToggleSelection;

  final VoidCallback? onDelete;

  const HomeWorkerAppBarWidget({
    super.key,
    required this.tabIndex,
    required this.isSelectionMode,
    required this.isDeleteEnabled,
    this.onToggleSelection,
    this.onDelete,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  bool get _isCanceledTab => tabIndex == 2;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: BlocBuilder<WorkerProfileBloc, WorkerProfileState>(
        builder: (context, state) {
          if (state is WorkerProfileError) {
            return const Text("Xatolik", style: TextStyle(color: Colors.black));
          }

          if (state is WorkerProfileSuccess) {
            final profile = state.workerProfileEntity;

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
                        pageBuilder: (_, __, ___) =>
                            WorkerProfileImageView(imageUrl: imageUrl),
                      ),
                    );
                  },
                  child: Hero(
                    tag: profileHeroTag,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: imageUrl != null
                          ? NetworkImage(imageUrl)
                          : const AssetImage('assets/profile/per.png')
                      as ImageProvider,
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

          return const SizedBox.shrink();
        },
      ),
      actions: [
        IconButton(onPressed:(){

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Ushbu xizmat hali mavjud emas!"),
                duration: Duration(seconds: 3),
              ));

          // Navigator.pushNamed(context, RouteNames.notification);
        },

            icon: SvgPicture.asset("assets/home/notification.svg")),

        IconButton(onPressed:(){

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Ushbu xizmat hali mavjud emas!"),
                duration: Duration(seconds: 3),
              ));
          },

            icon: SvgPicture.asset("assets/home/delete.svg")),
        //
        // if (_isCanceledTab)
        //   IconButton(
        //     onPressed: () {
        //       if (!isSelectionMode) {
        //         onToggleSelection?.call();
        //         return;
        //       }
        //
        //       if (!isDeleteEnabled) {
        //         onToggleSelection?.call();
        //         return;
        //       }
        //
        //       onDelete?.call();
        //     },
        //     icon: SvgPicture.asset(
        //       "assets/home/delete.svg",
        //       color: isSelectionMode ? Colors.red : null,
        //     ),
        //     tooltip: isSelectionMode
        //         ? (isDeleteEnabled ? "O‘chirish" : "Bekor qilish")
        //         : "Tanlash",
        //   ),

        SizedBox(width: 12.w),
      ],
    );
  }
}
