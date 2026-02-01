class ChatStaffEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String? image;
  final String profession;

  const ChatStaffEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.profession,
  });
}