import 'package:tez_xizmat/features/auth/domain/entities/verify_purpose.dart';

class VerifyEmailRequest {
  final String email;
  final String code;
  final VerifyPurpose? purpose;

  VerifyEmailRequest({
    required this.email,
    required this.code,
    this.purpose,
  });

  Map<String, dynamic> toJson() {
    final map = {"email": email, "code": code};

    if (purpose != null) {
      map["purpose"] = purpose!.value;
    }
    return map;
  }
}
