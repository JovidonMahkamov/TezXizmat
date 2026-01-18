abstract class AuthLocalDataSource {
  // Remember me
  Future<void> saveRememberMe(String email, String password);
  String? getEmail();
  String? getPassword();

  // Tokens
  Future<void> saveAccessToken(String accessToken);
  Future<void> saveRefreshToken(String refreshToken);
  String? getAccessToken();
  String? getRefreshToken();

  // User
  Future<void> saveUserId(int id);
  int? getUserId();

  // Clear
  Future<void> clearAll();
  // Role (customer/staff)
  Future<void> saveRole(String role); // 'customer' yoki 'staff'
  String? getRole();

}
