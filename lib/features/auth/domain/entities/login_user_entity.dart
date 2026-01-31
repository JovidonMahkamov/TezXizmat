class LoginUserEntity {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? image;
  final String? profession;
  final String? description;
  final String? skillsText;
  final String? priceText;
  final String? freeTimeText;
  final bool? isEmailVerified;
  final DateTime createdAt;

  const LoginUserEntity({
     this.email,
     this.firstName,
     this.lastName,
     this.image,
     this.profession,
     this.description,
     this.skillsText,
     this.priceText,
     this.freeTimeText,
     this.isEmailVerified,
     this.id,
    required this.createdAt
  });
}
