abstract class CustomerHomeEvent {
  const CustomerHomeEvent();
}

class CustomerGetAllStaff extends CustomerHomeEvent {

  final String search;
  const CustomerGetAllStaff({this.search = ''});
}

class GetWorkerInfoE extends CustomerHomeEvent {
  final int id;

  const GetWorkerInfoE({required this.id});
}

class GetWorkerReviewsE extends CustomerHomeEvent{
  final int id;
  const GetWorkerReviewsE({required this.id});
}