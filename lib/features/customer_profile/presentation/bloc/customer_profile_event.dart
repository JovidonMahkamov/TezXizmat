abstract class CustomerProfileEvent {
  const CustomerProfileEvent();
}

class CustomerProfileE extends CustomerProfileEvent {
  const CustomerProfileE();
}

class CustomerUpdateProfileE extends CustomerProfileEvent {
  final String name;
  final String surname;

  CustomerUpdateProfileE({required this.name, required this.surname});
}
