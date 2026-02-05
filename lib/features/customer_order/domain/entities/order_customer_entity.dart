import 'package:equatable/equatable.dart';

class OrderCustomerEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String image;

  const OrderCustomerEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, image];
}
