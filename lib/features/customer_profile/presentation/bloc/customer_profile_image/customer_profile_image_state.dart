import '../../../domain/entities/customer_profile_image_entity.dart';

abstract class  CustomerProfileImageState{
  const CustomerProfileImageState();
}

class CustomerProfileImageInitial extends CustomerProfileImageState {}

class CustomerProfileImageLoading extends CustomerProfileImageState {}

class CustomerProfileImageSuccess extends CustomerProfileImageState {
  final CustomerProfileImageEntity customerProfileImageEntity;


  const CustomerProfileImageSuccess({required this.customerProfileImageEntity,});
}

class CustomerProfileImageError extends CustomerProfileImageState {
  final String message;

  const CustomerProfileImageError({required this.message});
}
