import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/service_widget.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_state.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';
import '../../../worker_home/presentation/pages/worker_profile_image_view.dart';

const String profileHeroTag = "worker-profile-image";

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkerProfileBloc>().add(WorkerProfileE());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "Profil",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, RouteNames.workerSettings);
              if (mounted) {
                context.read<WorkerProfileBloc>().add(WorkerProfileE());
              }
            },
            icon: const Icon(Icons.settings),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<WorkerProfileBloc, WorkerProfileState>(
        builder: (context, state) {
          if (state is WorkerProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorkerProfileError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WorkerProfileBloc>().add(WorkerProfileE());
                    },
                    child: const Text("Qayta urinish"),
                  ),
                ],
              ),
            );
          }

          if (state is WorkerProfileSuccess) {
            final profile = state.workerProfileEntity;

            final imageUrl = profile.image.isNotEmpty
                ? (profile.image.startsWith('http')
                ? profile.image
                : 'https://tezxizmatlar.uz${profile.image}')
                : null;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  /// ===== PROFILE IMAGE (VIEW ONLY) =====
                  GestureDetector(
                    onTap: imageUrl == null
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (_, __, ___) =>
                              WorkerProfileImageView(
                                imageUrl: imageUrl,
                              ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: profileHeroTag,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl)
                            : const AssetImage(
                          'assets/profile/per.png',
                        ) as ImageProvider,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),
                  Text(
                    "${profile.firstName} ${profile.lastName}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    profile.email,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.sp,
                    ),
                  ),

                  SizedBox(height: 12.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),

                        _title("Ish turi"),
                        _text(profile.profession),

                        const Divider(),
                        _title("Tajriba"),
                        ReadMoreText(
                          profile.description,
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: " Read more",
                          trimExpandedText: " Read less",
                          style: TextStyle(fontSize: 14.sp),
                        ),

                        const Divider(),
                        _title("Xizmatlar"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: profile.skills
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .map(
                                (skill) => Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: serviceWidget(text: skill),
                            ),
                          )
                              .toList(),
                        ),

                        const Divider(),
                        _title("Narx"),
                        _text(profile.price),

                        const Divider(),
                        _title("Mavjud vaqt"),
                        _text(profile.freeTime),

                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _title(String text) => Padding(
    padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
    child: Text(
      text,
      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
    ),
  );

  Widget _text(String text) => Text(
    text,
    style: TextStyle(fontSize: 14.sp, color: const Color(0xff4D4D4D)),
  );
}
