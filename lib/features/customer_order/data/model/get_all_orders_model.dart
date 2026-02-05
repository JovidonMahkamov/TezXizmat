
import 'package:tez_xizmat/features/customer_order/data/model/order_customer_model.dart';
import 'package:tez_xizmat/features/customer_order/data/model/order_staff_model.dart';
import 'package:tez_xizmat/features/customer_order/domain/entities/get_all_orders_entity.dart';

class GetAllOrdersModel extends GetAllOrdersEntity {
  const GetAllOrdersModel({
    required super.id,
    required super.status,
    required super.address,
    required super.problemText,
    required super.customer,
    required super.staff,
    required super.createdAt,
    super.acceptedAt,
    super.canceledAt,
    super.canceledBy,
    super.cancelReason,
    super.completedByCustomerAt,
    super.completedByStaffAt,
    super.startedAt,
  });

  factory GetAllOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetAllOrdersModel(
      id: (json['id'] ?? 0) as int,
      status: (json['status'] ?? '') as String,
      address: (json['address'] ?? '') as String,
      problemText: (json['problem_text'] ?? '') as String,
      customer: OrderCustomerModel.fromJson(
        (json['customer'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      staff: OrderStaffModel.fromJson(
        (json['staff'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      createdAt: DateTime.tryParse((json['created_at'] ?? '') as String) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      acceptedAt: json['accepted_at'],
      startedAt: json['started_at'],
      completedByStaffAt: json['completed_by_staff_at'],
      completedByCustomerAt: json['completed_by_customer_at'],
      canceledAt: json['canceled_at'],

      canceledBy: json['canceled_by'],
      cancelReason: json['cancel_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'address': address,
      'problem_text': problemText,
      'customer': (customer as OrderCustomerModel).toJson(),
      'staff': (staff as OrderStaffModel).toJson(),
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  static List<GetAllOrdersModel> fromJsonList(List<dynamic> list) {
    return list
        .map((e) => GetAllOrdersModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}


