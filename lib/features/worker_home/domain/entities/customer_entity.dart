import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String fullName;

  const CustomerEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.fullName,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, fullName];
}
