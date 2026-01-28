class CustomerProfileEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String image;

  const CustomerProfileEntity({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.image,
  });
}
