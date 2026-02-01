import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tez_xizmat/core/network/customer_dio_client.dart';
import 'package:tez_xizmat/core/network/staff_dio_client.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_remote_data_source.dart';
import 'package:tez_xizmat/features/auth/data/datasource/remote/customer_remote_data_source.dart';
import 'package:tez_xizmat/features/auth/data/datasource/remote/customer_remote_data_source_impl.dart';
import 'package:tez_xizmat/features/auth/data/repository/customer_repository_impl.dart';
import 'package:tez_xizmat/features/auth/domain/repository/customer_repository.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_login_use_case.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_register_use_case.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_resend_email_use_case.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_send_email_use_case.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/customer_verify_email_use_case.dart';
import 'package:tez_xizmat/features/auth/domain/usecase/reset_password_use_case.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_login/customer_login_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_register/customer_register_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_resend_email/customer_resend_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_reset_password/customer_reset_password_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_send_email/customer_send_email_bloc.dart';
import 'package:tez_xizmat/features/auth/presentation/bloc/customer_verify_email/customer_verify_email_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/data/datasource/chat_remote_data_source.dart';
import 'package:tez_xizmat/features/customer_chat/data/datasource/chat_remote_data_source_impl.dart';
import 'package:tez_xizmat/features/customer_chat/data/datasource/chat_socket_data_source.dart';
import 'package:tez_xizmat/features/customer_chat/data/datasource/chat_socket_data_source_impl.dart';
import 'package:tez_xizmat/features/customer_chat/data/repositories/chat_repository_impl.dart';
import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/connect_chat_socket_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/disconnect_chat_socket_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/get_chat_rooms_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/get_room_messages_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/send_message_rest_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/send_message_socket_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/domain/usecase/socket_messages_use_case.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_detail/chat_detail_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_rooms/chat_rooms_bloc.dart';
import 'package:tez_xizmat/features/customer_home/data/datasource/customer_home_data_source.dart';
import 'package:tez_xizmat/features/customer_home/data/datasource/customer_home_data_source_impl.dart';
import 'package:tez_xizmat/features/customer_home/data/repository/customer_home_repository_impl.dart';
import 'package:tez_xizmat/features/customer_home/domain/repository/customer_home_repository.dart';
import 'package:tez_xizmat/features/customer_home/domain/usecase/customer_get_all_staff_use_case.dart';
import 'package:tez_xizmat/features/customer_home/domain/usecase/get_worker_info_use_case.dart';
import 'package:tez_xizmat/features/customer_home/domain/usecase/get_worker_reviews_use_case.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/customer_get_all_staff/customer_get_all_staff_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/get_worker_info/get_worker_info_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/bloc/get_worker_reviews/get_worker_reviews_bloc.dart';
import 'package:tez_xizmat/features/customer_order/data/datasource/customer_order_data_source.dart';
import 'package:tez_xizmat/features/customer_order/data/datasource/customer_order_data_source_impl.dart';
import 'package:tez_xizmat/features/customer_order/data/repository/customer_order_repository_impl.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/cancel_order_use_case.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/confirm_completion_use_case.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/customer_create_order_use_case.dart';
import 'package:tez_xizmat/features/customer_order/domain/usecase/customer_get_all_orders_use_case.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/cancel_order/cancel_order_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_create_order/customer_create_order_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/get_customer_all_orders/get_customer_all_orders_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/data/datasource/customer_profile_data_source.dart';
import 'package:tez_xizmat/features/customer_profile/data/datasource/customer_profile_data_source_impl.dart';
import 'package:tez_xizmat/features/customer_profile/data/repository/customer_profile_repository_impl.dart';
import 'package:tez_xizmat/features/customer_profile/domain/repository/customer_profile_repository.dart';
import 'package:tez_xizmat/features/customer_profile/domain/usecase/customer_profile_image_use_case.dart';
import 'package:tez_xizmat/features/customer_profile/domain/usecase/customer_profile_use_case.dart';
import 'package:tez_xizmat/features/customer_profile/domain/usecase/customer_update_profile_use_case.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/customer_profile_image/customer_profile_image_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/profile_bloc/customer_profile_bloc.dart';
import 'package:tez_xizmat/features/customer_profile/presentation/bloc/update_profile_bloc/customer_update_profile_bloc.dart';
import 'package:tez_xizmat/features/worker_home/data/datasource/worker_home_data_source.dart';
import 'package:tez_xizmat/features/worker_home/data/datasource/worker_home_data_source_impl.dart';
import 'package:tez_xizmat/features/worker_home/data/repository/worker_home_repository_impl.dart';
import 'package:tez_xizmat/features/worker_home/domain/repository/worker_home_repository.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/accept_order_use_case.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/complete_by_staff_use_case.dart';
import 'package:tez_xizmat/features/worker_home/domain/usecase/start_order_use_case.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/accept_order/accept_order_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/complete_by_staff_order/complete_by_staff_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/get_staff_orders/get_staff_orders_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/start_order/start_order_bloc.dart';
import 'package:tez_xizmat/features/worker_profile/data/datasources/worker_remote_data_source.dart';
import 'package:tez_xizmat/features/worker_profile/data/datasources/worker_remote_data_source_impl.dart';
import 'package:tez_xizmat/features/worker_profile/data/repositories/worker_profile_repository_impl.dart';
import 'package:tez_xizmat/features/worker_profile/domain/repositories/worker_repository.dart';
import 'package:tez_xizmat/features/worker_profile/domain/usecases/worker_edit_profile_use_case.dart';
import '../../features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_bloc.dart';
import '../../features/worker_home/domain/usecase/get_staff_orders_use_case.dart';
import '../../features/worker_profile/domain/usecases/worker_profile_image_use_case.dart';
import '../../features/worker_profile/domain/usecases/worker_profile_use_case.dart';
import '../../features/worker_profile/presentation/bloc/worker_edit_profile/worker_edit_profile_bloc.dart';
import '../../features/worker_profile/presentation/bloc/worker_profile/worker_profile_bloc.dart';
import '../../features/worker_profile/presentation/bloc/worker_profile_image/worker_profile_image_bloc.dart';
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
  /// DioClient
  sl.registerLazySingleton<StaffDioClient>(() => StaffDioClient(local: sl()));
  sl.registerLazySingleton<CustomerDioClient>(() => CustomerDioClient(local: sl()));

  ///! DataSource
  ///* Auth
  sl.registerLazySingleton<CustomerRemoteDataSource>(
        () => CustomerRemoteDataSourceImpl(customerDioClient: sl(), local: sl(), staffDioClient: sl()),
  );
  ///* Profile Customer
  sl.registerLazySingleton<CustomerProfileDataSource>(
        () => CustomerProfileDataSourceImpl(sl(), sl(), sl()),
  );
  ///* Profile Staff
  sl.registerLazySingleton<WorkerRemoteDataSource>(
          () => WorkerRemoteDataSourceImpl(sl(), sl(), sl()),
  );

  ///* Customer Order
  sl.registerLazySingleton<CustomerOrderDataSource>(
        () => CustomerOrderDataSourceImpl(sl(), sl(),),
  );

  ///* Customer Home
  sl.registerLazySingleton<CustomerHomeDataSource>(
        () => CustomerHomeDataSourceImpl(sl(), sl()),
  );

  ///* Worker Home
  sl.registerLazySingleton<WorkerHomeDataSource>(
        () => WorkerHomeDataSourceImpl(sl(), sl()),
  );
  ///* CHAT
  sl.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImpl(
      customerClient: sl(),
      staffClient: sl(),
      local: sl(),
    ),
  );

  sl.registerLazySingleton<ChatSocketDataSource>(
        () => ChatSocketDataSourceImpl(),
  );

  ///! Repository
  ///* Auth
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(customerRemoteDataSource: sl()),
  );
  ///* Profile Customer
  sl.registerLazySingleton<CustomerProfileRepository>(
        () => CustomerProfileRepositoryImpl(customerProfileDataSource: sl()),
  );
  ///* Profile Staff
  sl.registerLazySingleton<WorkerRepository>(
        () => WorkerProfileRepositoryImpl(workerRemoteDataSource: sl()),
  );
  ///* Customer Order
  sl.registerLazySingleton<CustomerOrderRepository>(
        () => CustomerOrderRepositoryImpl(customerOrderRemoteDataSource: sl()),
  );

  ///* Customer Home
  sl.registerLazySingleton<CustomerHomeRepository>(
        () => CustomerHomeRepositoryImpl(customerHomeDataSource: sl()),
  );

  ///* Worker Home
  sl.registerLazySingleton<WorkerHomeRepository>(
        () => WorkerHomeRepositoryImpl(workerHomeDataSource: sl()),
  );
  ///* CHAT
  sl.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImpl(
      remote: sl(),
      socket: sl(),
      local: sl(),
    ),
  );

  ///! UseCase
  ///*Auth
  sl.registerLazySingleton(()=>CustomerSendEmailUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerVerifyEmailUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerRegisterUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerLoginUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerResendEmailUseCase(sl()));
  sl.registerLazySingleton(()=>ResetPasswordUseCase(sl()));


  ///* Profile Customer
  sl.registerLazySingleton(()=>CustomerProfileUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerUpdateProfileUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerProfileImageUseCase(sl()));
  ///* Customer Order
  sl.registerLazySingleton(()=>CustomerCreateOrderUseCase(sl()));
  sl.registerLazySingleton(()=>CustomerGetAllOrdersUseCase(sl()));
  sl.registerLazySingleton(()=>CancelOrderUseCase(sl()));
  sl.registerLazySingleton(()=>ConfirmCompletionUseCase(sl()));
  sl.registerLazySingleton(()=>AcceptOrderUseCase(sl()));
  sl.registerLazySingleton(()=>StartOrderUseCase(sl()));
  sl.registerLazySingleton(()=>CompleteByStaffUseCase(sl()));
  ///* Customer Home
  sl.registerLazySingleton(()=>CustomerGetAllStaffUseCase(sl()));

  ///* Worker Home
  sl.registerLazySingleton(()=>GetStaffOrdersUseCase(sl()));
  ///* Worker Info
  sl.registerLazySingleton(()=>GetWorkerInfoUseCase(sl()));
  sl.registerLazySingleton(()=>GetWorkerReviewsUseCase(sl()));

  ///* Profile Staff
  sl.registerLazySingleton(()=>WorkerProfileUseCase(sl()));
  sl.registerLazySingleton(()=>WorkerEditProfileUseCase(sl()));
  sl.registerLazySingleton(()=>WorkerProfileImageUseCase(sl()));
  ///* CHAT
  sl.registerLazySingleton(() => GetChatRoomsUseCase(sl()));
  sl.registerLazySingleton(() => GetRoomMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageRestUseCase(sl()));
  sl.registerLazySingleton(() => ConnectChatSocketUseCase(sl()));
  sl.registerLazySingleton(() => DisconnectChatSocketUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageSocketUseCase(sl()));
  sl.registerLazySingleton(() => SocketMessagesUseCase(sl()));

  ///! Bloc
  ///* Auth
  sl.registerLazySingleton(()=> CustomerSendEmailBloc(sl()));
  sl.registerLazySingleton(()=> CustomerVerifyEmailBloc(sl()));
  sl.registerLazySingleton(()=> CustomerRegisterBloc(sl()));
  sl.registerLazySingleton(()=> CustomerLoginBloc(sl()));
  sl.registerLazySingleton(()=> CustomerResendEmailBloc(sl()));
  sl.registerLazySingleton(()=> CustomerResetPasswordBloc(sl()));

  ///* Profile Customer
  sl.registerFactory(() => CustomerProfileBloc(sl()));
  sl.registerFactory(() => CustomerUpdateProfileBloc(sl()));
  sl.registerFactory(() => CustomerProfileImageBloc(sl()));
  ///* Customer Order
  sl.registerFactory(() => CustomerCreateOrderBloc(sl()));
  sl.registerFactory(() => GetCustomerAllOrdersBloc(sl()));
  sl.registerFactory(() => CancelOrderBloc(sl()));
  sl.registerFactory(() => ConfirmCompletionBloc(sl()));
  sl.registerFactory(() => AcceptOrderBloc(sl()));
  sl.registerFactory(() => CompleteByStaffBloc(sl()));
  sl.registerFactory(() => StartOrderBloc(sl()));

  ///* Customer Home
  sl.registerFactory(() => CustomerGetAllStaffBloc(sl()));
  ///* Worker Home
  sl.registerFactory(() => GetStaffOrdersBloc(sl()));
  ///* Worker Info
  sl.registerFactory(() => GetWorkerInfoBloc(sl()));
  sl.registerFactory(() => GetWorkerReviewsBloc(sl()));

  ///* Profile Staff
  sl.registerFactory(() => WorkerProfileBloc(sl()));
  sl.registerFactory(() => WorkerEditProfileBloc(sl()));
  sl.registerFactory(() => WorkerProfileImageBloc(sl()));
  ///* CHAT
  sl.registerFactory(() => ChatRoomsBloc(getRooms: sl()));
  sl.registerFactory(
        () => ChatDetailBloc(
      getMessages: sl(),
      connectSocket: sl(),
      disconnectSocket: sl(),
      socketStream: sl(),
      sendSocket: sl(),
      sendRest: sl(),
    ),
  );

}


