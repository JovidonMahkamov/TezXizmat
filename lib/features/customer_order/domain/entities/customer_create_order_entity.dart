class CustomerCreateOrderEntity {
  final int id;
  final String? name;
  final String? surname;
  final String description;
  final String address;

  const CustomerCreateOrderEntity({
    required this.id,
    this.name,
    this.surname,
    required this.description,
    required this.address,
  });
}
