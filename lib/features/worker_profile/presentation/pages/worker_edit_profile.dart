import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget_2.dart';

import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_edit_profile/worker_edit_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_edit_profile/worker_edit_profile_state.dart';

import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_state.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';

import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_state.dart';

import 'package:tez_xizmat/features/worker_profile/presentation/widgets/worker_image_picker_widget.dart';
import '../../../../core/routes/route_names.dart';
import '../widgets/worker_drop_down_widget.dart';
import '../widgets/worker_service_add_widget.dart';

class WorkerEditProfilePage extends StatefulWidget {
  final bool forceComplete;

  const WorkerEditProfilePage({super.key, this.forceComplete = false});

  @override
  State<WorkerEditProfilePage> createState() => _WorkerEditProfilePageState();
}

class _WorkerEditProfilePageState extends State<WorkerEditProfilePage> {
  bool _prefilled = false;

  List<String> _initialServices = [];
  List<String> services = [];
  String? selectedProfession;

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final experienceController = TextEditingController();
  final cashController = TextEditingController();
  final timeController = TextEditingController();
  final professionController = TextEditingController();
  final skillsController = TextEditingController();

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

  bool _isBlank(String? v) =>
      v == null || v.trim().isEmpty || v.trim() == 'null';

  void _fillFromProfile(WorkerProfileSuccess st) {
    if (_prefilled) return;

    final p = st.workerProfileEntity;

    nameController.text = p.firstName ?? '';
    surnameController.text = p.lastName ?? '';
    experienceController.text = p.description ?? '';
    cashController.text = p.priceText ?? '';
    timeController.text = p.freeTimeText ?? '';

    selectedProfession = _isBlank(p.profession) ? null : p.profession;
    professionController.text = p.profession ?? '';

    _initialServices = (p.skillsText ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    services = List.from(_initialServices);
    skillsController.text = services.join(", ");

    _prefilled = true;
    setState(() {});
  }

  void _showSnack(String text, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text), backgroundColor: color));
  }

  bool _validate() {
    if (_isBlank(nameController.text) || _isBlank(surnameController.text)) {
      _showSnack("Ism va familiyani to‘ldiring", color: Colors.red);
      return false;
    }
    if (_isBlank(professionController.text)) {
      _showSnack("Ish turini tanlang", color: Colors.red);
      return false;
    }
    if (_isBlank(experienceController.text)) {
      _showSnack("Tajriba (description) ni kiriting", color: Colors.red);
      return false;
    }
    if (_isBlank(skillsController.text)) {
      _showSnack("Xizmatlar (skills) ni kiriting", color: Colors.red);
      return false;
    }
    if (_isBlank(cashController.text)) {
      _showSnack("Narxni kiriting", color: Colors.red);
      return false;
    }
    if (_isBlank(timeController.text)) {
      _showSnack("Mavjud vaqtni kiriting", color: Colors.red);
      return false;
    }
    return true;
  }

  void _saveProfile() {
    if (!_validate()) return;

    context.read<WorkerEditProfileBloc>().add(
      WorkerEditProfile(
        free_time_text: timeController.text.trim(),
        first_name: nameController.text.trim(),
        last_name: surnameController.text.trim(),
        profession: professionController.text.trim(),
        description: experienceController.text.trim(),
        skills_text: skillsController.text.trim(),
        price_text: cashController.text.trim(),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (widget.forceComplete) {
      _showSnack("Avval profilingizni to‘liq to‘ldiring", color: Colors.red);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return
        BlocListener<WorkerEditProfileBloc, WorkerEditProfileState>(
          listener: (context, state) {
            if (state is WorkerEditProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("O'zgartirishlar muvaffaqiyatli saqlandi"),
                ),
              );
              context.read<WorkerProfileBloc>().add(WorkerProfileE());
              if (widget.forceComplete) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.workerBottomNavBar,
                  (route) => false,
                  arguments: 0,
                );
              } else {
                // oddiy edit dan kirilgan bo'lsa
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, true);
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteNames.workerBottomNavBar,
                    arguments: 2, // masalan profil tab
                  );
                }
              }
            }
            if (state is WorkerEditProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Xatolik: ${state.message}")),
              );
            }
          },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: widget.forceComplete
                ? null
                : IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
            title: Text(
              "Profilni tahrirlash",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ====== IMAGE PICKER ======
                        Center(
                          child:
                              BlocConsumer<
                                WorkerProfileImageBloc,
                                WorkerProfileImageState
                              >(
                                listener: (context, imgState) {
                                  if (imgState is WorkerProfileImageError) {
                                    _showSnack(
                                      imgState.message,
                                      color: Colors.red,
                                    );
                                  }
                                },
                                builder: (context, imgState) {
                                  final profileState = context
                                      .watch<WorkerProfileBloc>()
                                      .state;
                                  String? imagePath;
                                  if (profileState is WorkerProfileSuccess) {
                                    imagePath =
                                        profileState.workerProfileEntity.image;
                                  }

                                  return WorkerImagePickerWidget(
                                    baseUrl: "https://tezxizmatlar.uz",
                                    initialImagePath: imagePath,
                                    uploadImage: (filePath) async {
                                      final bloc = context
                                          .read<WorkerProfileImageBloc>();

                                      final completer = Completer<String>();
                                      late final StreamSubscription sub;

                                      sub = bloc.stream.listen((s) {
                                        if (s is WorkerProfileImageSuccess) {
                                          // profilni yangilab olamiz
                                          context.read<WorkerProfileBloc>().add(
                                            WorkerProfileE(),
                                          );

                                          completer.complete(
                                            s.workerProfileImageEntity.image,
                                          );
                                          sub.cancel();
                                        } else if (s
                                            is WorkerProfileImageError) {
                                          completer.completeError(s.message);
                                          sub.cancel();
                                        }
                                      });

                                      bloc.add(
                                        WorkerProfileImage(filePath: filePath),
                                      );
                                      return completer.future;
                                    },
                                  );
                                },
                              ),
                        ),

                        SizedBox(height: 16.h),

                        Text(
                          'Ism',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 2.h),
                        TextFieldWidget(
                          text: "",
                          obscureText: false,
                          controller: nameController,
                          readOnly: false,
                        ),

                        SizedBox(height: 14.h),
                        Text(
                          'Familiya',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 2.h),
                        TextFieldWidget(
                          text: "",
                          obscureText: false,
                          controller: surnameController,
                          readOnly: false,
                        ),

                        SizedBox(height: 14.h),
                        Text(
                          'Ish turi',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 2.h),
                        CustomDropdown(
                          value: selectedProfession,
                          onChanged: (val) {
                            setState(() => selectedProfession = val);
                            professionController.text = val ?? '';
                          },
                        ),

                        SizedBox(height: 14.h),
                        Text(
                          'Tajribangiz haqida batafsil',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 2.h),
                        TextFieldWidgetTwo(
                          maxLine: 4,
                          text: "Tajribangiz haqida batafsil kiriting...",
                          obscureText: false,
                          controller: experienceController,
                        ),

                        SizedBox(height: 14.h),
                        Text(
                          'Xizmatlar',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 2.h),
                        ServicesFieldsWidget(
                          key: ValueKey(_initialServices.join('|')),
                          initialValues: _initialServices,
                          onChanged: (list) {
                            services = list;
                            skillsController.text = services.join(", ");
                          },
                        ),

                        SizedBox(height: 14.h),
                        Text(
                          'Narx',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 2.h),
                        TextFieldWidgetTwo(
                          maxLine: 2,
                          text: "Boshlang'ich narxni kiriting...",
                          obscureText: false,
                          controller: cashController,
                        ),

                        SizedBox(height: 14.h),
                        Text(
                          'Mavjud vaqt',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
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

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                // ====== LOADING OVERLAY (UI yo‘qolib ketmaydi) ======
                BlocBuilder<WorkerEditProfileBloc, WorkerEditProfileState>(
                  builder: (context, state) {
                    if (state is! WorkerEditProfileLoading) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      color: Colors.black.withOpacity(0.25),
                      child: Center(
                        child: SizedBox(
                          width: 90.w,
                          height: 90.w,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballSpinFadeLoader,
                            colors: const [Colors.blueAccent],
                            strokeWidth: 2.w,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
