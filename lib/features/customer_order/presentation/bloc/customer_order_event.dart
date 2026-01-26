abstract class CustomerOrderEvent {
  const CustomerOrderEvent();
}

class CustomerCreateOrder extends CustomerOrderEvent {
  final int staff_id;
  final String name;
  final String surname;
  final String description;
  final String address;

  const CustomerCreateOrder({required this.staff_id, required this.surname, required this.name, required this.description, required this.address});
}

class GetCustomerAllOrdersE extends CustomerOrderEvent {
  const GetCustomerAllOrdersE();
}