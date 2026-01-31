
class GetWorkerInfoEntity{
  final String firstName;
  final String lastName;
  final String image;
  final String profession;
  final String description;
  final String skillsText;
  final String priceText;
  final int id;
  final String freeTimeText;
  final double avgStar;
  final int ratingsCount;
  final int textReviewsCount;

  const GetWorkerInfoEntity({
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.skillsText,
    required this.profession,
    required this.priceText,
    required this.id,
    required this.avgStar,
    required this.freeTimeText,
    required this.description,
    required this.ratingsCount,
    required this.textReviewsCount,
  });
}
