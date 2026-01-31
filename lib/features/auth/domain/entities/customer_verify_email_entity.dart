class CustomerVerifyEmailEntity{
  final String message;
  final String email;
  final String purpose;
  const CustomerVerifyEmailEntity({
    required this.message,
    required this.email,
    required this.purpose,
  });
}