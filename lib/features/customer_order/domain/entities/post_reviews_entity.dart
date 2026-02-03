class PostReviewsEntity {
  final int id;
  final int orderId;
  final int stars;
  final String text;
  final String createdAt;
  final int customerId;
  final int staffId;
  final String customer;
  final String staff;

  const PostReviewsEntity({
    required this.id,
    required this.stars,
    required this.staffId,
    required this.staff,
    required this.customer,
    required this.customerId,
    required this.text,
    required this.createdAt,
    required this.orderId,
  });
}