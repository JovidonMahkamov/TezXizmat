import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tez_xizmat/features/worker_chat/presentation/pages/worker_chat.dart';
import 'package:tez_xizmat/features/worker_home/presentation/pages/worker_home.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/pages/worker_profile.dart';


class WorkerBottomNavBarPage extends StatefulWidget {
  final int initialIndex;
  const WorkerBottomNavBarPage({super.key,  this.initialIndex= 0});

  @override
  State<WorkerBottomNavBarPage> createState() => _WorkerBottomNavBarPageState();
}

class _WorkerBottomNavBarPageState extends State<WorkerBottomNavBarPage> {
  int _currentIndex = 0;
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> pages = [
    WorkerHomePage(),
    WorkerChatPage(),
    WorkerProfilePage(),
  ];

  final List<String> _icons = [
    "assets/bottom_nav_bar/home.svg",
    "assets/bottom_nav_bar/chat.svg",
    "assets/bottom_nav_bar/profile.svg",
  ];

  final List<String> _labels = [
    "Bosh sahifa",
    "Xabarlar",
    "Profil",
  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      _currentIndex = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
            setState(() {
              _currentIndex = newIndex;
            });
          },
          selectedItemColor: Color(0xff1778F2),
          unselectedItemColor: Color(0xff939393),
          showUnselectedLabels: true,
          items: List.generate(_icons.length, (index) {
            return BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _icons[index],
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _currentIndex == index ? Color(0xff1778F2) : Color(0xff939393),
                  BlendMode.srcIn,
                ),
              ),
              label: _labels[index],
            );
          }),
        ),
      ),
    );
  }
}
