import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_state.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_container_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_home_event.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textEditingController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // Page ochilganda hamma staffni olib kelish (bo'sh search)
    WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CustomerGetAllStaffBloc>().add(const CustomerGetAllStaff(search: ''));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce: user yozishni to'xtatgandan 350ms keyin API chaqiradi
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      context.read<CustomerGetAllStaffBloc>().add(CustomerGetAllStaff(search: value.trim()));
    });
    setState(() {}); // faqat "X" icon ko'rinishi uchun
  }

  void _clearSearch() {
    textEditingController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Qidiruv",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFieldWidget(
              controller: textEditingController,
              text: "Qidiruv",
              obscureText: false,
              readOnly: false,
              suffixIcon: textEditingController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSearch,
              )
                  : null,
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: 16.h),

            // Natijalar:
            Expanded(
              child: BlocBuilder<CustomerGetAllStaffBloc, CustomerGetAllStaffState>(
                builder: (context, state) {
                  if (state is CustomerGetAllStaffLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is CustomerGetAllStaffError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CustomerGetAllStaffBloc>().add(
                                CustomerGetAllStaff(
                                  search: textEditingController.text.trim(),
                                ),
                              );
                            },
                            child: const Text("Qayta urinish"),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is CustomerGetAllStaffSuccess) {
                    final list = state.customerGetAllStaffEntity;

                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          "Hech narsa topilmadi",
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final item = list[index];

                        // ⚠️ Bu joyda field nomlarini o'zingizning modelga moslang:
                        // masalan: item.id, item.firstName, item.profession, item.image
                        final int id = item.id;
                        final String name =
                        "${item.first_name} ${item.last_name}".trim();
                        final String profession = item.profession ?? '';
                        debugPrint("staff.image(raw) = '${item.image}'");
                        final raw0 = item.image?.trim();
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
                          circularImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : const AssetImage("assets/profile/per.png") as ImageProvider,
                          nameText: name.isEmpty ? "Nomsiz" : name,
                          profession: profession,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.workerInfo,
                              arguments: {"id": id},
                            );
                          },
                        );
                      },
                    );
                  }
                  // initial holat
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
