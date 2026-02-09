import 'package:tez_xizmat/features/worker_profile/domain/entities/worker_profile_entity.dart';

bool isWorkerProfileComplete(WorkerProfileEntity p) {
  bool ok(String? s) => s != null && s.trim().isNotEmpty && s.trim() != 'null';

  return ok(p.firstName) &&
      ok(p.lastName) &&
      ok(p.profession) &&
      ok(p.description) &&
      ok(p.skillsText) &&
      ok(p.priceText) &&
      ok(p.freeTimeText);

}
