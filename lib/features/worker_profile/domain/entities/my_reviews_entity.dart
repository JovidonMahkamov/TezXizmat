class MyReviewsEntity {
  final int id;
  final int orderId;
  final int stars;
  final String text;
  final String createdAt;
  final int customerId;
  final int staffId;
  final Map<String, dynamic> customer;
  final Map<String, dynamic> staff;


  const MyReviewsEntity({
    required this.id,
    required this.orderId,
    required this.stars,
    required this.text,
    required this.createdAt,
    required this.customerId,
    required this.customer,
    required this.staff,
    required this.staffId,
  });
}
