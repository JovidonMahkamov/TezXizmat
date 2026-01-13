abstract class ApiUrls{
  static const String baseUrl = 'https://tezxizmatlar.uz';

  /// customer
  static const String customer = '/api/auth/customer/';

  //Auth
  static const String sendEmail = '${customer}send-email/';
  static const String verifyEmail = '${customer}verify-email/';
  static const String registerCustomer = '${customer}register/';
  // static const String statistics = '/statistics';
  // static const String result = '/result';
  // static const String onlineCourses = '/online-courses';
  // static const String dashboardCourses = '/dashboard-course/28';

}