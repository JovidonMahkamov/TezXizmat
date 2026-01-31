abstract class WorkerHomeEvent {
  const WorkerHomeEvent();
}

class GetStaffOrdersE extends WorkerHomeEvent {
  const GetStaffOrdersE();
}
class AcceptStaffOrderE extends WorkerHomeEvent {
  final int id;
  AcceptStaffOrderE(this.id);
}

class CancelStaffOrderE extends WorkerHomeEvent {
  final int id;
  CancelStaffOrderE(this.id);
}

class CompleteStaffOrderE extends WorkerHomeEvent {
  final int id;
  CompleteStaffOrderE(this.id);
}

class StartStaffOrderE extends WorkerHomeEvent {
  final int id;
  StartStaffOrderE(this.id);
}

class AcceptOrderE extends WorkerHomeEvent {
  final int id;
  AcceptOrderE({required this.id});
}

class StartOrderE extends WorkerHomeEvent {
  final int id;
  StartOrderE({required this.id});
}

class CompleteOrderE extends WorkerHomeEvent {
  final int id;
  CompleteOrderE({required this.id});
}