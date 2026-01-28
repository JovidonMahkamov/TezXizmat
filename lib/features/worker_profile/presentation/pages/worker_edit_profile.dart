import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget_2.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_edit_profile/worker_edit_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_edit_profile/worker_edit_profile_state.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/widgets/worker_image_picker_widget.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_state.dart';
import 'dart:async';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_state.dart';

import '../widgets/worker_drop_down_widget.dart';
import '../widgets/worker_service_add_widget.dart';

class WorkerEditProfilePage extends StatefulWidget {
  const WorkerEditProfilePage({super.key});

  @override
  State<WorkerEditProfilePage> createState() => _WorkerEditProfilePageState();
}

class _WorkerEditProfilePageState extends State<WorkerEditProfilePage> {
  bool _prefilled = false;
  List<String> _initialServices = [];
  String? selectedProfession;
  List<String> services = [];

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final experienceController = TextEditingController();
  final cashController = TextEditingController();
  final timeController = TextEditingController();
  final professionController = TextEditingController();
  final skillsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    experienceController.dispose();
    cashController.dispose();
    timeController.dispose();
    professionController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (nameController.text.trim().isEmpty || surnameController.text.trim().isEmpty) return;
    if (professionController.text.trim().isEmpty || skillsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profession va Skills ni to‘ldiring")),
      );
      return;
    }

    context.read<WorkerEditProfileBloc>().add(
      WorkerEditProfile(
        free_time: timeController.text.trim(),
        first_name: nameController.text.trim(),
        last_name: surnameController.text.trim(),
        profession: professionController.text.trim(),
        description: experienceController.text.trim(),
        skills: skillsController.text.trim(),
        price: cashController.text.trim(),
        // agar backend qabul qilsa keyin services ham qo‘shamiz
      ),
    );
  }
  @override
  void initState() {
    super.initState();

    final st = context.read<WorkerProfileBloc>().state;
    if (st is WorkerProfileSuccess) {
      _fillFromProfile(st);
    } else {
      context.read<WorkerProfileBloc>().add(WorkerProfileE());
    }
  }

  void _fillFromProfile(WorkerProfileSuccess st) {
    if (_prefilled) return;

    final p = st.workerProfileEntity;

    nameController.text = p.firstName;
    surnameController.text = p.lastName;
    experienceController.text = p.description;
    cashController.text = p.price;
    timeController.text = p.freeTime;

    selectedProfession = p.profession;
    professionController.text = p.profession;

    // "a, b, c" => ["a","b","c"]
    _initialServices = p.skills
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    services = List.from(_initialServices);
    skillsController.text = services.join(", ");

    _prefilled = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WorkerProfileBloc, WorkerProfileState>(
          listener: (context, state) {
            if (state is WorkerProfileSuccess) {
              _fillFromProfile(state);
            }
          },
        ),
        BlocListener<WorkerEditProfileBloc, WorkerEditProfileState>(
          listener: (context, state) {
            if (state is WorkerEditProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("O'zgartirishlar muvaffaqiyatli saqlandi")),
              );
              Navigator.pop(context, state.workerEditProfileEntity);
            } else if (state is WorkerEditProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Xatolik: ${state.message}')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Profilni tahrirlash",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: BlocBuilder<WorkerEditProfileBloc, WorkerEditProfileState>(
              builder: (context, state) {
                if (state is WorkerEditProfileLoading) {
                  return Center(
                    child: SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballSpinFadeLoader,
                        colors: const [Colors.blueAccent],
                        strokeWidth: 2.w,
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            final profileState = context.watch<WorkerProfileBloc>().state;
                            String? imagePath;

                            if (profileState is WorkerProfileSuccess) {
                              imagePath = profileState.workerProfileEntity.image;
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
                                    context.read<WorkerProfileBloc>().add(WorkerProfileE());

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
                      SizedBox(height: 16.h),

                      Text('Ism', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      SizedBox(height: 2.h),
                      TextFieldWidget(
                        text: "",
                        obscureText: false,
                        controller: nameController,
                        readOnly: false,
                      ),

                      SizedBox(height: 14.h),
                      Text('Familiya', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      SizedBox(height: 2.h),
                      TextFieldWidget(
                        text: "",
                        obscureText: false,
                        controller: surnameController,
                        readOnly: false,
                      ),

                      SizedBox(height: 14.h),
                      Text('Ish turi', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      SizedBox(height: 2.h),
                      CustomDropdown(
                        value: selectedProfession,
                        onChanged: (val) {
                          setState(() => selectedProfession = val);
                          professionController.text = val ?? '';
                        },
                      ),

                      SizedBox(height: 14.h),
                      Text('Tajribangiz haqida batafsil', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      SizedBox(height: 2.h),
                      TextFieldWidgetTwo(
                        maxLine: 4,
                        text: "Tajribangiz haqida batafsil kiriting...",
                        obscureText: false,
                        controller: experienceController,
                      ),

                      SizedBox(height: 14.h),
                      SizedBox(height: 14.h),
                      Text('Xizmatlar', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      SizedBox(height: 2.h),
                      ServicesFieldsWidget(
                        key: ValueKey(_initialServices.join('|')), // ✅ initialValues kelsa widget qayta qurilsin
                        initialValues: _initialServices,           // ✅ eski skill/service lar chiqadi
                        onChanged: (list) {
                          services = list;
                          skillsController.text = services.join(", "); // ✅ backend uchun string
                        },
                      ),


                      SizedBox(height: 14.h),
                      Text('Narx', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      SizedBox(height: 2.h),
                      TextFieldWidgetTwo(
                        maxLine: 2,
                        text: "Boshlang'ich narxni kiriting...",
                        obscureText: false,
                        controller: cashController,
                      ),

                      SizedBox(height: 14.h),
                      Text('Mavjud vaqt', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      SizedBox(height: 2.h),
                      TextFieldWidgetTwo(
                        maxLine: 1,
                        text: "Bosh vaqtingizni kiriting...",
                        obscureText: false,
                        controller: timeController,
                      ),

                      SizedBox(height: 24.h),
                      ElevatedWidget(
                        onPressed: _saveProfile,
                        text: "Saqlash",
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
