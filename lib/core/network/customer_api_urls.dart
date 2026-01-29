abstract class CustomerApiUrls{
  static const String baseUrl = 'https://tezxizmatlar.uz';

  /// CUSTOMER
  static const String customer = '/api/auth/customer/';
  /// STAFF
  static const String staff = '/api/auth/staff/';

  // AUTH
  static const String sendEmail = '${customer}send-email/';
  static const String verifyEmail = '${customer}verify-email/';
  static const String registerCustomer = '${customer}register/';
  static const String loginCustomer = '${customer}login/';
  static const String resendEmailCustomer = '${customer}resend-email/';
  static const String resetPasswordCustomer = '${customer}reset-password/';

  // ORDER
  static const String createOrder = '/api/orders/create/';
  static const String getCusAllOrders = '/api/orders/customer-orders/';

  // HOME
  static const String getAllStaff = '/api/staff/';

  // WORKER INFO
  static const String getWorkerInfo = '/api/staff/';
  static const String getWorkerReviews = '/api/reviews/staff/';

  // TOKEN
  static const String refreshCustomer = '${customer}token/refresh/';
  static const String refreshStaff = '${staff}token/refresh/';

  //PROFILE
  static const String updateImage = '${customer}profile/image/';
}