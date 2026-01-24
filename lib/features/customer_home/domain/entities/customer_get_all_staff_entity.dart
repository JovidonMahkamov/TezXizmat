class CustomerGetAllStaffEntity{
  final String first_name;
  final String last_name;
  final String image;
  final String profession;
  final String price;
  final int id;
  final String free_time;
  final double avg_rating;
  final int ratings_count;

  const CustomerGetAllStaffEntity({
    required this.first_name,
    required this.last_name,
    required this.image,
    required this.profession,
    required this.price,
    required this.id,
    required this.avg_rating,
    required this.free_time,
    required this.ratings_count,
  });
}
