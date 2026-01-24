abstract class CustomerHomeEvent {
  const CustomerHomeEvent();
}

class CustomerGetAllStaff extends CustomerHomeEvent {
  const CustomerGetAllStaff();
}

class GetWorkerInfoE extends CustomerHomeEvent {
  final int id;

  const GetWorkerInfoE({required this.id});
}