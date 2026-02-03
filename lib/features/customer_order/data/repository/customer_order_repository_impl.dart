import 'package:tez_xizmat/features/customer_order/data/datasource/customer_order_data_source.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/post_reviews_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class CustomerOrderRepositoryImpl implements CustomerOrderRepository{
  final CustomerOrderDataSource customerOrderRemoteDataSource;

  CustomerOrderRepositoryImpl({required this.customerOrderRemoteDataSource});

  @override
  Future<CustomerCreateOrderEntity> createOrder({required int staff_id, required String description, required String address}) {
    return customerOrderRemoteDataSource.createOrder(staff_id: staff_id, description: description, address: address);
  }

  @override
  Future<List<GetAllOrdersEntity>> getCusAllOrders() {
    return customerOrderRemoteDataSource.getCusAllOrders();
  }

  @override
  Future<CancelOrderEntity> cancelOrder({required String reason, required int id}) {
    return customerOrderRemoteDataSource.cancelOrder(reason: reason, id: id);
  }

  @override
  Future<void> confirmCompletion({required int id}) {
    return customerOrderRemoteDataSource.confirmCompletion(id: id);
  }

  @override
  Future<PostReviewsEntity> postReview({required int orderId, required int stars, required String text}) {
    return customerOrderRemoteDataSource.postReviews(orderId: orderId, stars: stars, text: text);
  }
}