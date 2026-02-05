abstract class CustomerOrderEvent {
  const CustomerOrderEvent();
}

class CustomerCreateOrder extends CustomerOrderEvent {
  final int staff_id;
  final String description;
  final String address;

  const CustomerCreateOrder({required this.staff_id, required this.description, required this.address});
}

class GetCustomerAllOrdersE extends CustomerOrderEvent {
  const GetCustomerAllOrdersE();
}

class CancelOrderE extends CustomerOrderEvent {
  final int id;
  final String reason;

  const CancelOrderE({required this.reason, required this.id});
}

class ConfirmCompletionE extends CustomerOrderEvent {
  final int id;

  const ConfirmCompletionE({required this.id});
}

class PostReviewsE extends CustomerOrderEvent {
  final int orderId;
  final int stars;
  final String text;

  const PostReviewsE({required this.orderId, required this.stars, required this.text});
}

class DeleteOrderE extends CustomerOrderEvent {
  final int id;

  const DeleteOrderE({required this.id});
}

class DeleteOrdersE extends CustomerOrderEvent {
  final List<int> ids;
  const DeleteOrdersE({required this.ids});
}
