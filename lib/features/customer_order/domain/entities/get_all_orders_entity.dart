class GetAllOrdersEntity {
  final int id;
  final int customerId;
  final int staffId;
  final String problemText;
  final String address;
  final String status;

  final String? acceptedAt;
  final String? startedAt;
  final String? completedByStaffAt;
  final String? completedByCustomerAt;
  final String? canceledAt;

  final String? canceledBy;
  final String? cancelReason;

  final String createdAt;

  GetAllOrdersEntity({
    required this.id,
    required this.customerId,
    required this.staffId,
    required this.problemText,
    required this.address,
    required this.status,
    this.acceptedAt,
    this.startedAt,
    this.completedByStaffAt,
    this.completedByCustomerAt,
    this.canceledAt,
    this.canceledBy,
    this.cancelReason,
    required this.createdAt,
  });
}