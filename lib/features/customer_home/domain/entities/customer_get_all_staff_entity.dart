class CustomerGetAllStaffEntity{
  final String first_name;
  final String last_name;
  final String? image;
  final String profession;

  final int id;

  const CustomerGetAllStaffEntity({
    required this.first_name,
    required this.last_name,
     this.image,
    required this.profession,
    required this.id,
  });
}
