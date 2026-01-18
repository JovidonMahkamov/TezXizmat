abstract class ApiUrls{
  static const String baseUrl = 'https://tezxizmatlar.uz';

  /// customer
  static const String customer = '/api/auth/customer/';
  static const String staff = '/api/auth/staff/';

  //Auth Customer
  static const String sendEmail = '${customer}send-email/';
  static const String verifyEmail = '${customer}verify-email/';
  static const String registerCustomer = '${customer}register/';
  static const String loginCustomer = '${customer}login/';

  //Auth Staff
  static const String sendEmailStaff = '${staff}send-email/';
  static const String verifyEmailStaff = '${staff}verify-email/';
  static const String registerStaff = '${staff}register/';
  static const String loginStaff = '${staff}login/';


// static const String statistics = '/statistics';
  // static const String result = '/result';
  // static const String onlineCourses = '/online-courses';
  // static const String dashboardCourses = '/dashboard-course/28';

}