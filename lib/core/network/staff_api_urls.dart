abstract class StaffApiUrls {
  static const String baseUrl = 'https://tezxizmatlar.uz';

  /// STAFF
  static const String staff = '/api/auth/staff/';
  /// CUSTOMER
  static const String customer = '/api/auth/customer/';

  // AUTH
  static const String sendEmailStaff = '/api/auth/api/auth/staff/send-email/';
  static const String verifyEmailStaff = '/api/auth/api/auth/staff/verify-email/';
  static const String registerStaff = '${staff}register/';
  static const String loginStaff = '${staff}login/';
  static const String resendEmailStaff = '/api/auth/api/auth/staff/resend-email/';
  static const String resetPasswordStaff = '${staff}reset-password/';

  // PROFILE
  static const String getStaffProfile = '${staff}profile/';
  static const String updateStaffProfile = '${staff}profile/';
  static const String staffProfileImage = "${staff}profile/image/";
  static const String getMyReviews = "/api/reviews/staff/my/";

  // HOME
  static const String getStaffOrders = '/api/orders/staff-orders/';

  // ORDERS STATE
  static String acceptOrder(int id) => "/api/orders/$id/accept/";
  static String cancelOrder(int id) => "/api/orders/$id/cancel/";
  static String completeOrder(int id) => "/api/orders/$id/complete/";
  static String startOrder(int id) => "/api/orders/$id/start/";
  static const String acceptOrderByW = "/api/orders/";
  static const String startOrderByW = "/api/orders/";
  static const String completeOrderByW = "/api/orders/";

  // TOKEN
  static const String refreshCustomer = '${customer}token/refresh/';
  static const String refreshStaff = '${staff}token/refresh/';
}