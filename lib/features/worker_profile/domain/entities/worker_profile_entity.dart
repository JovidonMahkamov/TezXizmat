class WorkerProfileEntity {
  final int id;
  final String email;
  final String image;
  final String firstName;
  final String lastName;
  final String profession;
  final String description;
  final String skillsText;
  final String priceText;
  final bool isEmailVerified;
  final String createdAt;
  final String freeTimeText;

  const WorkerProfileEntity({
    required this.image,
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profession,
    required this.description,
    required this.skillsText,
    required this.priceText,
    required this.isEmailVerified,
    required this.createdAt,
    required this.freeTimeText,
  });
}
