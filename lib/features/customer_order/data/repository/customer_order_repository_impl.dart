import 'package:tez_xizmat/features/customer_order/data/datasource/customer_order_data_source.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/customer_create_order_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_customer_all_orders_entity.dart';
import 'package:tez_xizmat/features/customer_order/domain/repository/customer_order_repository.dart';

class CustomerOrderRepositoryImpl implements CustomerOrderRepository{
  final CustomerOrderDataSource customerOrderRemoteDataSource;

  CustomerOrderRepositoryImpl({required this.customerOrderRemoteDataSource});

  @override
  Future<CustomerCreateOrderEntity> createOrder({required int staff_id, required String name, required String surname, required String description, required String address}) {
    return customerOrderRemoteDataSource.createOrder(staff_id: staff_id, name: name, surname: surname, description: description, address: address);
  }

  @override
  Future<List<GetCustomerAllOrdersEntity>> getCusAllOrders() {
    return customerOrderRemoteDataSource.getCusAllOrders();
  }
}