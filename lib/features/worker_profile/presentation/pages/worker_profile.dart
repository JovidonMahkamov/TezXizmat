import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/service_widget.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_state.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';
import '../widgets/worker_image_picker_widget.dart';
import 'dart:async';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_state.dart';


class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerInfoPageState();
}

class _WorkerInfoPageState extends State<WorkerProfilePage> {
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
          // 1) LOADING
          if (state is WorkerProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) ERROR
          if (state is WorkerProfileError) {
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
                        context.read<WorkerProfileBloc>().add(WorkerProfileE());
                      },
                      child: const Text("Qayta urinish"),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3) LOADED
          if (state is WorkerProfileSuccess) {
            final profile = state.workerProfileEntity;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: BlocConsumer<WorkerProfileImageBloc, WorkerProfileImageState>(
                      listener: (context, imgState) {
                        if (imgState is WorkerProfileImageError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(imgState.message)),
                          );
                        }
                      },
                      builder: (context, imgState) {
                        // image pathni bloc state’dan olamiz
                        String? imagePath;
                        if (imgState is WorkerProfileImageSuccess) {
                          imagePath = imgState.workerProfileImageEntity.image; // "/media/..."
                        }

                        return WorkerImagePickerWidget(
                          baseUrl: "https://tezxizmatlar.uz",
                          initialImagePath: imagePath, // <-- endi state.profile.image emas
                          uploadImage: (filePath) async {
                            // Widget Future<String> kutyapti, shuning uchun bloc’dan natijani kutib qaytaramiz
                            final bloc = context.read<WorkerProfileImageBloc>();

                            final completer = Completer<String>();
                            late final StreamSubscription sub;

                            sub = bloc.stream.listen((s) {
                              if (s is WorkerProfileImageSuccess) {
                                completer.complete(s.workerProfileImageEntity.image);
                                sub.cancel();
                              } else if (s is WorkerProfileImageError) {
                                completer.completeError(s.message);
                                sub.cancel();
                              }
                            });

                            bloc.add(WorkerProfileImage(filePath: filePath));

                            return completer.future;
                          },
                        );
                      },
                    ),
                  ),


                  SizedBox(height: 10.h),
                  Text("${profile.firstName} ${profile.lastName}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(profile.email,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
              
                  Padding(
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(child: Divider()),
                        Text(
                          "Ish turi",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(profile.profession,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xff4D4D4D),
                          ),
                        ),
                        SizedBox(child: Divider()),
                        Text(
                          "Tajriba",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ReadMoreText(
                          profile.description,
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: " Read more",
                          trimExpandedText: " Read less",
                          style: TextStyle(fontSize: 14.sp),
                          moreStyle: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                          lessStyle: TextStyle(
                            color: Color(0xff1778F2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              
                        SizedBox(child: Divider()),
                        Text(
                          "Xizmatlar",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: profile.skills
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .map((skill) => Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: serviceWidget(text: skill),
                          ))
                              .toList(),
                        ),
              
                        SizedBox(child: Divider()),
                        Text(
                          "Narx",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          profile.price,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xff4D4D4D),
                          ),
                        ),
                        SizedBox(child: Divider()),
                        Text(
                          "Mavjud vaqt",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          profile.freeTime,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xff4D4D4D),
                          ),
                        ),
                        SizedBox(child: Divider()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Default (agar state initial bo‘lsa)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
