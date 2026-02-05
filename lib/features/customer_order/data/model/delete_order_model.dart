import 'package:tez_xizmat/features/customer_order/domain/entities/delete_order_entity.dart';

class DeleteOrderModel extends DeleteOrderEntity {
  const DeleteOrderModel({required super.data});

  factory DeleteOrderModel.fromJson(Map<String, dynamic> json) {
    return DeleteOrderModel(
      data: json.map((k, v) => MapEntry(k, (v ?? '').toString())),
    );
  }
}
