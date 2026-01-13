import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/core/di/services_locator.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_register/customer_register_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_verify_email/customer_verify_email_bloc.dart';

class MyBlocProvider extends StatelessWidget {
  const MyBlocProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerSendEmailBloc>(create: (context) => sl<CustomerSendEmailBloc>()),
        BlocProvider<CustomerVerifyEmailBloc>(create: (context) => sl<CustomerVerifyEmailBloc>()),
        BlocProvider<CustomerRegisterBloc>(create: (context) => sl<CustomerRegisterBloc>()),
      ],
      child: child,
    );
  }
}
