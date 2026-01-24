class CustomerLoginEntity {
  final String refresh;
  final String access;
  final String email;
  final String first_name;
  final String last_name;
  final int id;

  const CustomerLoginEntity({
    required this.refresh,
    required this.access,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.id,
  });
}
