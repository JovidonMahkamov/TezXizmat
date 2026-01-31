class CustomerUpdateProfileEntity {
  final String email;
  final String firstName;
  final String lastName;
  final int id;
  final String image;
  final String is_email_verified;
  final String created_at;

  const CustomerUpdateProfileEntity({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.image,
    required this.is_email_verified,
    required this.created_at,
  });
}