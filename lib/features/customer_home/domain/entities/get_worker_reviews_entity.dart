class GetWorkerReviewsEntity{
  final int staff;
  final int rating;
  final String comment;
  final String created_at;
  final int id;

  const GetWorkerReviewsEntity({
    required this.staff,
    required this.rating,
    required this.comment,
    required this.created_at,
    required this.id,
  });
}
