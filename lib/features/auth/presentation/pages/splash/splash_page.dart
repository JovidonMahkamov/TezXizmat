import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _listenInternetChanges();

    // SnackBar/Context muammosi bo'lmasligi uchun post frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkRealInternet();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _listenInternetChanges() {
    _subscription =
        Connectivity().onConnectivityChanged.listen((results) async {

          final hasInternet =
              results.contains(ConnectivityResult.mobile) ||
                  results.contains(ConnectivityResult.wifi);

          if (!mounted) return;

          if (hasInternet && !_hasNavigated) {
            await _navigateToNextPage();
          } else if (!hasInternet && !_hasNavigated) {
            _showNoInternetSnackBar();
          }
        });
  }


  Future<void> _checkRealInternet() async {
    final hasInternet = await InternetConnectionChecker().hasConnection;

    if (!mounted) return;

    if (hasInternet) {
      await _navigateToNextPage();
    } else {
      _showNoInternetSnackBar();
    }
  }

  void _showNoInternetSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Internet mavjud emas. Iltimos, tarmoqni tekshiring!"),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _navigateToNextPage() async {
    if (_hasNavigated) return;
    _hasNavigated = true;

    await _subscription?.cancel();

    // Splash ekranda 2 sekund turadi
    await Future.delayed(const Duration(seconds: 2));

    // Hive authBox
    final box = await Hive.openBox('authBox');
    final accessToken = box.get('accessToken');
    final refreshToken = box.get('refreshToken');

    if (!mounted) return;

    final hasAccessToken =
        accessToken != null && accessToken.toString().trim().isNotEmpty;

    final hasRefreshToken =
        refreshToken != null && refreshToken.toString().trim().isNotEmpty;


    // Loginda bo'lgan deb hisoblash (accessToken bo'lsa yetadi)
    final role = box.get('role', defaultValue: 'customer');

    if (hasAccessToken && hasRefreshToken) {
      Navigator.pushReplacementNamed(
        context,
        role == 'staff'
            ? RouteNames.workerBottomNavBar
            : RouteNames.customerBottomNavBar,
      );
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.carousel);
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // orqaga bosganda app chiqib ketadi
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: LogoWidget()),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.38),
        SvgPicture.asset(
          'assets/splash/logo.svg',
          height: 70.h,
          width: 170.w,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 261.h,
          child: SvgPicture.asset(
            'assets/splash/ellipse.svg',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
