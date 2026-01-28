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
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  StreamSubscription<InternetConnectionStatus>? _internetSub;

  bool _hasNavigated = false;
  bool _snackShown = false;

  final InternetConnectionChecker _checker = InternetConnectionChecker();

  @override
  void initState() {
    super.initState();

    // SnackBar uchun context tayyor bo‘lishi kerak
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initialCheck();
      _listenNetworkChanges();
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _internetSub?.cancel();
    super.dispose();
  }

  /// App ochilganda 1-marta real internet tekshirish
  Future<void> _initialCheck() async {
    final hasInternet = await _checker.hasConnection;
    if (!mounted) return;

    if (hasInternet) {
      await _navigateToNextPage();
    } else {
      _showNoInternetSnackBar();
    }
  }

  /// Internet yoqilganda avtomatik o‘tishi uchun listenerlar
  void _listenNetworkChanges() {
    // 1) Tarmoq turi o‘zgarsa (wifi/mobile/none)
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((results) async {
          if (!mounted || _hasNavigated) return;

          final hasAnyNetwork =
              results.isNotEmpty && !results.contains(ConnectivityResult.none);

          if (!hasAnyNetwork) {
            _showNoInternetSnackBar();
            return;
          }

          // wifi/mobile ulandi -> real internet bormi tekshiramiz
          final hasInternet = await _checker.hasConnection;
          if (!mounted || _hasNavigated) return;

          if (hasInternet) {
            await _navigateToNextPage();
          } else {
            _showNoInternetSnackBar();
          }
        });

    // 2) Real internet status (wifi ulangan bo‘lsa ham internet yo‘q bo‘lishi mumkin)
    _internetSub = _checker.onStatusChange.listen((status) async {
      if (!mounted || _hasNavigated) return;

      if (status == InternetConnectionStatus.connected) {
        await _navigateToNextPage();
      } else {
        _showNoInternetSnackBar();
      }
    });
  }

  void _showNoInternetSnackBar() {
    if (!mounted) return;

    // SnackBar qayta-qayta spam bo‘lmasin
    if (_snackShown) return;
    _snackShown = true;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Internet mavjud emas. Iltimos, tarmoqni yoqing!"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      _snackShown = false;
    });
  }

  Future<void> _navigateToNextPage() async {
    if (_hasNavigated) return;
    _hasNavigated = true;

    // Listenerlarni to‘xtatamiz
    await _connectivitySub?.cancel();
    await _internetSub?.cancel();

    // Splash 2 sekund turadi
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final box = await Hive.openBox('authBox');
    final accessToken = box.get('accessToken');
    final refreshToken = box.get('refreshToken');
    final role = box.get('role', defaultValue: 'customer');

    final hasAccess =
        accessToken != null && accessToken.toString().trim().isNotEmpty;
    final hasRefresh =
        refreshToken != null && refreshToken.toString().trim().isNotEmpty;

    if (!mounted) return;


    if (hasAccess && hasRefresh) {
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
        SystemNavigator.pop();
        return false;
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: LogoWidget()),
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

