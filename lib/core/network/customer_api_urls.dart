abstract class CustomerApiUrls{
  static const String baseUrl = 'https://tezxizmatlar.uz';

  /// CUSTOMER
  static const String customer = '/api/auth/customer/';
  /// STAFF
  static const String staff = '/api/auth/staff/';

  // AUTH
  static const String sendEmail = '/api/auth/api/auth/customer/send-email/';
  static const String verifyEmail = '/api/auth/api/auth/customer/verify-email/';
  static const String registerCustomer = '${customer}register/';
  static const String loginCustomer = '${customer}login/';
  static const String resendEmailCustomer = '/api/auth/api/auth/customer/resend-email/';
  static const String resetPasswordCustomer = '${customer}reset-password/';

  // ORDER
  static const String createOrder = '/api/orders/create/';
  static const String getCusAllOrders = '/api/orders/customer-orders/';
  static const String cancelOrder = '/api/orders/';
  static const String confirmCompletion = '/api/orders/';
  static const String postReviews = '/api/reviews/';
  static const String deleteOrder = '/api/orders/';

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
  static const String getProfile = '${customer}profile/';
  static const String updateProfile = '${customer}profile/';

  //CHAT
  static const String findChat = '/api/chat/rooms/find/';
  static const String deleteChat = '/api/chat/';
}