import 'package:tez_xizmat/features/customer_order/domain/entities/cancel_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/delete_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/post_reviews_entity.dart';
import '../entities/get_all_orders_entity.dart';

abstract class CustomerOrderRepository {
  Future<CustomerCreateOrderEntity> createOrder({
    required int staff_id,
    required String description,
    required String address,
  });

  Future<List<GetAllOrdersEntity>> getCusAllOrders();

  Future<CancelOrderEntity> cancelOrder({required String reason, required int id});

  Future<void> confirmCompletion({required int id});

  Future<PostReviewsEntity> postReview({required int orderId, required int stars, required String text});

  Future<DeleteOrderEntity> deleteOrder({required int id});

}
