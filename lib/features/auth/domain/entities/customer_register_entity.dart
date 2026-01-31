class CustomerRegisterEntity {

  // staff uchun
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profession;
  final String? image;
  final String? createdAt;
  final String? description;
  final String? skills;
  final String? price;
  final String? freeTime;
  final bool? isActive;

  const CustomerRegisterEntity({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profession,
    this.createdAt,
    this.description,
    this.skills,
    this.price,
    this.freeTime,
    this.isActive,
    this.image,
  });
}
