class GetStaffOrderEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String profession;
  final String description;
  final String skills;
  final String price;
  final String freeTime;
  final String image;
  final bool isActive;
  final String fullName;

  GetStaffOrderEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profession,
    required this.description,
    required this.skills,
    required this.price,
    required this.freeTime,
    required this.image,
    required this.isActive,
    required this.fullName,
  });
}