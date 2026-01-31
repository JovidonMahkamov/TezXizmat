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
  final String skills_text;
  final String price_text;
  final String free_time_text;


  const WorkerEditProfile({
    required this.first_name,
    required this.last_name,
    required this.profession,
    required this.description,
    required this.skills_text,
    required this.price_text,
    required this.free_time_text,
  });
}
class WorkerProfileImage extends WorkerProfileEvent {
  final String filePath;
  const WorkerProfileImage({required this.filePath});
}