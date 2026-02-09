import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/worker_chat/presentation/pages/worker_chat.dart';
import 'package:tez_xizmat/features/worker_home/presentation/pages/worker_home.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/pages/worker_profile.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_event.dart';
import '../worker_profile/presentation/bloc/worker_profile/worker_profile_state.dart';

class WorkerBottomNavBarPage extends StatefulWidget {
  final int initialIndex;
  const WorkerBottomNavBarPage({super.key, this.initialIndex = 0});

  @override
  State<WorkerBottomNavBarPage> createState() => _WorkerBottomNavBarPageState();
}

class _WorkerBottomNavBarPageState extends State<WorkerBottomNavBarPage> {
  int _currentIndex = 0;

  bool _sentToForceEdit = false;

  final List<Widget> pages = const [
    WorkerHomePage(),
    WorkerChatPage(),
    WorkerProfilePage(),
  ];

  final List<String> _icons = const [
    "assets/bottom_nav_bar/home.svg",
    "assets/bottom_nav_bar/chat.svg",
    "assets/bottom_nav_bar/profile.svg",
  ];

  final List<String> _labels = const [
    "Bosh sahifa",
    "Xabarlar",
    "Profil",
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<WorkerProfileBloc>().add(WorkerProfileE());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      _currentIndex = args;
    }
  }

  bool _isProfileComplete(dynamic p) {
    bool ok(String? s) => s != null && s.trim().isNotEmpty && s.trim() != 'null';

    return ok(p.firstName) &&
        ok(p.lastName) &&
        ok(p.profession) &&
        ok(p.description) &&
        ok(p.skillsText) &&
        ok(p.priceText) &&
        ok(p.freeTimeText);

  }

  void _goForceEditProfile() {
    if (_sentToForceEdit) return;
    _sentToForceEdit = true;

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.workerEditProfile,
          (route) => false,
      arguments: {"forceComplete": true},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkerProfileBloc, WorkerProfileState>(
      listener: (context, state) {
        if (state is WorkerProfileSuccess) {
          final profile = state.workerProfileEntity;
          final complete = _isProfileComplete(profile);

          if (!complete) {
            _goForceEditProfile();
          }
        }

      },
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (int newIndex) {
              setState(() => _currentIndex = newIndex);
            },
            selectedItemColor: const Color(0xff1778F2),
            unselectedItemColor: const Color(0xff939393),
            showUnselectedLabels: true,
            items: List.generate(_icons.length, (index) {
              return BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _icons[index],
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    _currentIndex == index
                        ? const Color(0xff1778F2)
                        : const Color(0xff939393),
                    BlendMode.srcIn,
                  ),
                ),
                label: _labels[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
