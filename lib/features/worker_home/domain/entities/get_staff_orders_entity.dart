class GetStaffOrdersEntity{
  final int id;
  final String title;
  final String description;
  final String address;
  final String status;
  final String accepted_at;
  final String completed_at;
  final String canceled_at;
  final String created_at;
  final String updated_at;
  final int customer;
  final int staff;

  const GetStaffOrdersEntity({
    required this.title,
    required this.description,
    required this.address,
    required this.status,
    required this.accepted_at,
    required this.id,
    required this.completed_at,
    required this.canceled_at,
    required this.created_at,
    required this.updated_at,
    required this.customer,
    required this.staff,
  });
}
