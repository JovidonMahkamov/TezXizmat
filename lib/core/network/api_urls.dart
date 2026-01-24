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
  static const String resendEmailCustomer = '${customer}resend-email/';
  static const String resetPasswordCustomer = '${customer}reset-password/';

  // Order Customer
  static const String createOrder = '/api/orders/create/';
  // Customer Home
  static const String getAllStaff = '/api/staff/';
  // Worker Info
  static const String getWorkerInfo = '/api/staff/';


  //Auth Staff
  static const String sendEmailStaff = '${staff}send-email/';
  static const String verifyEmailStaff = '${staff}verify-email/';
  static const String registerStaff = '${staff}register/';
  static const String loginStaff = '${staff}login/';
  static const String resendEmailStaff = '${staff}resend-email/';
  static const String resetPasswordStaff = '${staff}reset-password/';

  //Staff Profile
  static const String getStaffProfile = '${staff}profile/';
  static const String updateStaffProfile = '${staff}profile/';
  static const String staffProfileImage = "${staff}profile/image/";


// static const String statistics = '/statistics';
  // static const String result = '/result';
  // static const String onlineCourses = '/online-courses';
  // static const String dashboardCourses = '/dashboard-course/28';
  static const String refreshCustomer = '${customer}token/refresh/';
  static const String refreshStaff = '${staff}token/refresh/';

}