import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_home_event.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/get_worker_info/get_worker_info_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/get_worker_info/get_worker_info_state.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/pop_up_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/rating_info_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/service_widget.dart';

class WorkerInfoPage extends StatefulWidget {
  final int id;
  const WorkerInfoPage({super.key, required this.id,});


  @override
  State<WorkerInfoPage> createState() => _WorkerInfoPageState();
}

class _WorkerInfoPageState extends State<WorkerInfoPage> {
  @override
  void initState() {
    context.read<GetWorkerInfoBloc>().add(GetWorkerInfoE(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Ma'lumot",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.chatWithWorker, arguments:{"name": "Jovidon (Santexnik)", "urlAsset": "assets/circular_avatar/profile.png"} );
            },
            icon: SvgPicture.asset(
              "assets/home/message.svg",
              width: 28,
              height: 28,
            ),
          ),
        ],
      ),



      body: BlocBuilder<GetWorkerInfoBloc, GetWorkerInfoState>(
        builder: (context, state) {
          // 1) LOADING
          if (state is GetWorkerInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) ERROR
          if (state is GetWorkerInfoError) {
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
                        context.read<GetWorkerInfoBloc>().add(GetWorkerInfoE(id: widget.id));
                      },
                      child: const Text("Qayta urinish"),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3) LOADED
          if (state is GetWorkerInfoSuccess) {

            final getWorkerInfo = state.getWorkerInfoEntity;
            final img = getWorkerInfo.image.trim();
            // String? bo‘lsin
            final imageUrl = img.isEmpty
                ? null
                : (img.startsWith('http') ? img : 'https://tezxizmatlar.uz$img');
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


              CircleAvatar(
              radius: 50,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : const AssetImage("assets/circular_avatar/profile.png") as ImageProvider,
            ),

            SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${getWorkerInfo.first_name}${getWorkerInfo.last_name}",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                getWorkerInfo.profession,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF4D4D4D),
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/home/star.svg",
                                    width: 18,
                                    height: 18,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    getWorkerInfo.avg_rating.toString(),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Flexible(
                                    child: TextButton(
                                      onPressed: () {
                                        showRatingSheet(context);
                                      },
                                      child: Text(
                                        getWorkerInfo.ratings_count.toString(),
                                        style: TextStyle(
                                          color: Color(0xff1778F2),
                                          fontSize: 15.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(child: Divider()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tajriba",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ReadMoreText(
                          getWorkerInfo.description,
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
                      ],
                    ),
                    SizedBox(child: Divider()),
                    Text(
                      "Xizmatlar",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10.h),
                    serviceWidget(text: getWorkerInfo.skills),
                    serviceWidget(text: getWorkerInfo.skills),
                    serviceWidget(text: getWorkerInfo.skills),
                    SizedBox(child: Divider()),
                    Text(
                      "Narx",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      getWorkerInfo.price,
                      style: TextStyle(fontSize: 14.sp,color: Color(0xff4D4D4D)),
                    ),
                    SizedBox(child: Divider(),),
                    Text(
                      "Mavjud vaqt",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      getWorkerInfo.free_time,
                      style: TextStyle(fontSize: 14.sp,color: Color(0xff4D4D4D)),
                    ),
                    SizedBox(child: Divider(),),
                    SizedBox(height: 20.h,),
                    ElevatedWidget(onPressed: (){
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CreateOrderDialog(staffId: getWorkerInfo.id,
                        ),
                      );
                    }, text: "Bog'lanish", backgroundColor:  Color(0xff1778F2), textColor: Colors.white,),
                    SizedBox(height: 30.h,),
                  ],
                ),
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









