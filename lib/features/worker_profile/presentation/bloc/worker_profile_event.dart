abstract class WorkerProfileEvent {
  const WorkerProfileEvent();
}

class WorkerProfileE extends WorkerProfileEvent {
  const WorkerProfileE();
}

class WorkerEditProfile extends WorkerProfileEvent {
  final String first_name;
  final String last_name;
  final String profession;

  final String description;
  final String skills;
  final String price;
  final String free_time;

  const WorkerEditProfile({
    required this.first_name,
    required this.last_name,
    required this.profession,

    required this.description,
    required this.skills,
    required this.price,
    required this.free_time,
  });
}
class WorkerProfileImage extends WorkerProfileEvent {
  final String filePath;
  const WorkerProfileImage({required this.filePath});
}