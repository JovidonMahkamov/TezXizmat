class CustomerSendEmailEntity {
  final String message;
  final String email;
  final String purpose;
  final int expires_in;

  const CustomerSendEmailEntity({
    required this.message,
    required this.email,
    required this.purpose,
    required this.expires_in,
  });
}
