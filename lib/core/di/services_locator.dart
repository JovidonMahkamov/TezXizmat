import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_remote_data_source.dart';
import 'package:tez_xizmat/features/auth/data/datasource/remote/customer_remote_data_source.dart';
import 'package:tez_xizmat/features/auth/data/datasource/remote/customer_remote_data_source_impl.dart';
import 'package:tez_xizmat/features/auth/data/repository/customer_repository_impl.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_login_use_case.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_register_use_case.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_send_email_use_case.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_verify_email_use_case.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_login/customer_login_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_register/customer_register_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_verify_email/customer_verify_email_bloc.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => Dio());
  await Hive.initFlutter();
  await GetStorage.init();
  //! Hive
  final authBox = await Hive.openBox('authBox');
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(authBox),
  );

  ///! DataSource
  ///* Auth
  sl.registerLazySingleton<CustomerRemoteDataSource>(
        () => CustomerRemoteDataSourceImpl(local: sl()),
  );


  ///! Repository
  ///* Auth
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(customerRemoteDataSource: sl()),
  );

  ///! UseCase
  ///*Auth
  sl.registerLazySingleton(()=>CustomerSendEmailUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerVerifyEmailUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerRegisterUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerLoginUseCase(sl()));

  ///! Bloc
  ///* Auth
  sl.registerLazySingleton(()=> CustomerSendEmailBloc(sl()));
  sl.registerLazySingleton(()=> CustomerVerifyEmailBloc(sl()));
  sl.registerLazySingleton(()=> CustomerRegisterBloc(sl()));
  sl.registerLazySingleton(()=> CustomerLoginBloc(sl()));
}
