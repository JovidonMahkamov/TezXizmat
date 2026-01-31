class PutOrdersStateEntity {
  final int id;
  final String status;
  final String address;
  final String problemText;
  final int customerId;
  final int staffId;

  final OrderCustomerShortEntity customer; // workerga customer kerak
  final String createdAt;

  final String? acceptedAt;
  final String? startedAt;
  final String? completedByStaffAt;
  final String? completedByCustomerAt;
  final String? canceledAt;

  final String? canceledBy;
  final String? cancelReason;

  const PutOrdersStateEntity({
    required this.id,
    required this.status,
    required this.address,
    required this.problemText,
    required this.customerId,
    required this.staffId,
    required this.customer,
    required this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedByStaffAt,
    this.completedByCustomerAt,
    this.canceledAt,
    this.canceledBy,
    this.cancelReason,
  });
}

class OrderCustomerShortEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String image;

  const OrderCustomerShortEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
  });
}