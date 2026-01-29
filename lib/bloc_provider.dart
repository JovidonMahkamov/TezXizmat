import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/core/di/services_locator.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_login/customer_login_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_register/customer_register_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_resend_email/customer_resend_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_reset_password/customer_reset_password_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_verify_email/customer_verify_email_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/get_worker_info/get_worker_info_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/get_worker_reviews/get_worker_reviews_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_create_order/customer_create_order_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_image/customer_profile_image_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/update_profile_bloc/customer_update_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/get_staff_orders/get_staff_orders_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_edit_profile/worker_edit_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_bloc.dart';

import 'features/worker_home/presentation/bloc/put_orders_state/put_orders_state_bloc.dart';

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
        BlocProvider<CustomerLoginBloc>(create: (context) => sl<CustomerLoginBloc>()),
        BlocProvider<CustomerProfileBloc>(create: (context) => sl<CustomerProfileBloc>()),
        BlocProvider<CustomerResendEmailBloc>(create: (context) => sl<CustomerResendEmailBloc>()),
        BlocProvider<CustomerResetPasswordBloc>(create: (context) => sl<CustomerResetPasswordBloc>()),
        BlocProvider<CustomerUpdateProfileBloc>(create: (context) => sl<CustomerUpdateProfileBloc>()),
        BlocProvider<WorkerProfileBloc>(create: (context) => sl<WorkerProfileBloc>()),
        BlocProvider<WorkerEditProfileBloc>(create: (context) => sl<WorkerEditProfileBloc>()),
        BlocProvider<WorkerProfileImageBloc>(create: (context) => sl<WorkerProfileImageBloc>()),
        BlocProvider<CustomerCreateOrderBloc>(create: (context) => sl<CustomerCreateOrderBloc>()),
        BlocProvider<CustomerGetAllStaffBloc>(create: (context) => sl<CustomerGetAllStaffBloc>()),
        BlocProvider<GetWorkerInfoBloc>(create: (context) => sl<GetWorkerInfoBloc>()),
        BlocProvider<GetWorkerReviewsBloc>(create: (context) => sl<GetWorkerReviewsBloc>()),
        BlocProvider<GetCustomerAllOrdersBloc>(create: (context) => sl<GetCustomerAllOrdersBloc>()),
        BlocProvider<GetStaffOrdersBloc>(create: (context) => sl<GetStaffOrdersBloc>()),
        BlocProvider<PutStaffOrderBloc>(create: (context) => sl<PutStaffOrderBloc>()),
        BlocProvider<CustomerProfileImageBloc>(create: (context) => sl<CustomerProfileImageBloc>()),
      ],
      child: child,
    );
  }
}
