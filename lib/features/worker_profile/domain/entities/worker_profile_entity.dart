class WorkerProfileEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String profession;
  final String comments;
  final String description;
  final String skills;
  final String price;
  final String freeTime;
  final bool isActive;

  const WorkerProfileEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profession,
    required this.comments,
    required this.description,
    required this.skills,
    required this.price,
    required this.freeTime,
    required this.isActive,
  });
}
