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