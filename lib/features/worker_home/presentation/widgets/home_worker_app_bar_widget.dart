import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/worker_home/presentation/pages/worker_profile_image_view.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_state.dart';

class HomeWorkerAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final int tabIndex; // 0,1,2
  final bool isSelectionMode;
  final bool isDeleteEnabled; // selectedIndexes.isNotEmpty
  final VoidCallback? onEnterSelection; // delete_outline bosilganda
  final VoidCallback? onDelete; // delete bosilganda

  const HomeWorkerAppBarWidget({
    super.key,
    required this.tabIndex,
    required this.isSelectionMode,
    required this.isDeleteEnabled,
    this.onEnterSelection,
    this.onDelete,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
        IconButton(
          onPressed: () => Navigator.pushNamed(context, RouteNames.notification),
          icon: SvgPicture.asset("assets/home/notification.svg"),
        ),
        if (tabIndex == 2 && !isSelectionMode)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: onEnterSelection,
          ),

        if (tabIndex == 2 && isSelectionMode)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: isDeleteEnabled ? onDelete : null,
          ),
        SizedBox(width: 12.w),
      ],
    );
  }
}
