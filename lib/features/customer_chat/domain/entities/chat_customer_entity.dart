class ChatUserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String? image;

  const ChatUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
  });
}