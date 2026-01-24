class CustomerRegisterEntity {
  // customer uchun
  final String? detail;   // ba'zida detail keladi
  final String? message;  // ba'zida message keladi

  // staff uchun
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profession;
  final String? comments;
  final String? description;
  final String? skills;
  final String? price;
  final String? freeTime;
  final bool? isActive;

  const CustomerRegisterEntity({
    this.detail,
    this.message,
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profession,
    this.comments,
    this.description,
    this.skills,
    this.price,
    this.freeTime,
    this.isActive,
  });
}
