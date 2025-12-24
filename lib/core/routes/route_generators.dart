
import 'package:flutter/material.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/Customer_register/customer_forgot_password.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/Customer_register/customer_forgot_password_otp.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/Customer_register/customer_new_password.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/Customer_register/customer_register.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/Customer_register/customer_register_info.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/Customer_register/customer_login.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/Customer_register/verification_otp.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/role_select/select_page.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/splash/onboarding_page.dart';
import 'package:tez_xizmat/features/auth/presentation/pages/splash/splash_page.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/pages/chat_with_worker.dart';
import 'package:tez_xizmat/features/customer_home/presentation/pages/notification.dart';
import 'package:tez_xizmat/features/customer_home/presentation/pages/search.dart';
import 'package:tez_xizmat/features/customer_home/presentation/pages/worker_info.dart';
import 'package:tez_xizmat/features/customer_order/presentation/pages/order_view.dart';
import 'package:tez_xizmat/features/select_bottom_navbar/customer_bottom_nav_bar.dart';
import 'package:tez_xizmat/features/select_bottom_navbar/worker_bottom_nav_bar.dart';
import 'package:tez_xizmat/features/worker_chat/presentation/pages/chat_with_customer.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/pages/worker_edit_profile.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/pages/worker_profile.dart';

class AppRoute {
  BuildContext context;

  AppRoute({required this.context});

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case RouteNames.carousel:
        return MaterialPageRoute(builder: (_) => const CarouselPage());
      case RouteNames.select:
        return MaterialPageRoute(builder: (_) => const SelectPage());
      case RouteNames.customerRegister:
        return MaterialPageRoute(builder: (_) =>  CustomerRegisterPage());
      case RouteNames.verificationOtp:
        final phone = routeSettings.arguments as String;
        return MaterialPageRoute(builder: (_) =>  VerificationPage(phoneNumber: phone,));
      case RouteNames.customerRegisterInfo:
        return MaterialPageRoute(builder: (_) =>  CustomerRegisterInfoPage());
      case RouteNames.customerLogin:
        return MaterialPageRoute(builder: (_) =>  CustomerLoginPage());
      case RouteNames.customerForgotPassword:
        return MaterialPageRoute(builder: (_) =>  CustomerForgotPasswordPage());
      case RouteNames.customerForgotPasswordOtp:
        final phone = routeSettings.arguments as String;
        return MaterialPageRoute(builder: (_) =>  CustomerForgotPasswordOtpPage(phoneNumber: phone,));
      case RouteNames.customerNewPassword:
        return MaterialPageRoute(builder: (_) => const CustomerNewPasswordPage());
      case RouteNames.customerBottomNavBar:
        return MaterialPageRoute(builder: (_) => const CustomerBottomNavBarPage());
      case RouteNames.workerBottomNavBar:
        return MaterialPageRoute(builder: (_) => const WorkerBottomNavBarPage());
      case RouteNames.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case RouteNames.workerInfo:
        return MaterialPageRoute(builder: (_) => const WorkerInfoPage());
      case RouteNames.chatWithWorker:
        final urlPath = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) =>  ChatWithWorkerPage(name: urlPath["name"], urlAsset: urlPath["urlAsset"],));
      case RouteNames.notification:
        return MaterialPageRoute(builder: (_) => const NotificationPage());
      case RouteNames.orderView:
        return MaterialPageRoute(builder: (_) => const OrderViewPage());
      case RouteNames.chatWithCustomer:
        final urlPath = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) =>  ChatWithCustomerPage(name: urlPath["name"], urlAsset: urlPath["urlAsset"],));
      case RouteNames.workerProfile:
        return MaterialPageRoute(builder: (_) => const WorkerProfilePage());
      case RouteNames.workerEditProfile:
        return MaterialPageRoute(builder: (_) => const WorkerEditProfilePage());
      default:
        return _errorRoute();
    }
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
