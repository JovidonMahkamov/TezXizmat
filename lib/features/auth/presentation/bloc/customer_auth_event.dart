import 'package:tez_xizmat/features/auth/domain/entities/verify_purpose.dart';

abstract class CustomerAuthEvent {
  const CustomerAuthEvent();
}

class CustomerSendEmail extends CustomerAuthEvent {
  final String email;

  const CustomerSendEmail({required this.email});
}

class CustomerVerifyEmail extends CustomerAuthEvent {
  final String email;
  final String password;
  final VerifyPurpose purpose;

  const CustomerVerifyEmail({
    required this.purpose,
    required this.email,
    required this.password,
  });
}

class CustomerRegister extends CustomerAuthEvent {
  final String email;
  final String password;
  final String confirm_password;
  final String name;
  final String surname;

  const CustomerRegister({
    required this.confirm_password,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
  });
}

class CustomerLogin extends CustomerAuthEvent {
  final String email;
  final String password;

  const CustomerLogin({required this.email, required this.password});
}

class CustomerResendEmail extends CustomerAuthEvent {
  final String email;

  const CustomerResendEmail({required this.email});
}
class CustomerResetPassword extends CustomerAuthEvent {
  final String email;
  final String password;
  final String confirm_password;

  const CustomerResetPassword({
    required this.confirm_password,
    required this.email,
    required this.password,
  });
}
