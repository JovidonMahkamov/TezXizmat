class GetWorkerInfoEntity{
  final String first_name;
  final String last_name;
  final String image;
  final String email;
  final String profession;
  final String description;
  final String skills;
  final String price;
  final int id;
  final String free_time;
  final double avg_rating;
  final int ratings_count;
  final int reviews_text_count;

  const GetWorkerInfoEntity({
    required this.first_name,
    required this.last_name,
    required this.image,
    required this.email,
    required this.skills,
    required this.profession,
    required this.price,
    required this.id,
    required this.avg_rating,
    required this.free_time,
    required this.description,
    required this.ratings_count,
    required this.reviews_text_count,
  });
}
