abstract class CustomerAuthEvent {
  const CustomerAuthEvent();
}
class CustomerSendEmail extends CustomerAuthEvent {
  final String email;

  const CustomerSendEmail({required this.email,});
}
class CustomerVerifyEmail extends CustomerAuthEvent {
  final String email;
  final String password;

  const CustomerVerifyEmail( {required this.email,required this.password,});
}
class CustomerRegister extends CustomerAuthEvent {
  final String email;
  final String password;
  final String confirm_password;
  final String name;
  final String surname;


  const CustomerRegister({required this.confirm_password, required this.name, required this.surname, required this.email,required this.password,});
}