import 'package:equatable/equatable.dart';

class OrderStaffEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String image;

  final String profession;
  final String description;
  final String skillsText;
  final String priceText;
  final String freeTimeText;

  const OrderStaffEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.profession,
    required this.description,
    required this.skillsText,
    required this.priceText,
    required this.freeTimeText,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    image,
    profession,
    description,
    skillsText,
    priceText,
    freeTimeText,
  ];
}
