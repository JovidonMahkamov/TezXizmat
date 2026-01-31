class WorkerProfileImageEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String image;
  final String profession;
  final String description;
  final String skillsText;
  final String priceText;
  final String freeTimeText;

  final num avgStar;
  final int ratingsCount;
  final int textReviewsCount;

  const WorkerProfileImageEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.profession,
    required this.description,
    required this.skillsText,
    required this.priceText,
    required this.freeTimeText,
    required this.avgStar,
    required this.ratingsCount,
    required this.textReviewsCount,
  });
}