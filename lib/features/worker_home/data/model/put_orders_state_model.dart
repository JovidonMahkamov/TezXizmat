import 'package:tez_xizmat/features/worker_home/domain/entities/put_orders_state_entity.dart';

class PutOrdersStateModel extends PutOrdersStateEntity {
  const PutOrdersStateModel({
    required super.id,
    required super.title,
    required super.description,
    required super.address,
    required super.status,
    required super.acceptedAt,
    required super.completedAt,
    required super.canceledAt,
    required super.createdAt,
    required super.updatedAt,
    required super.customer,
    required super.staff,
  });

  factory PutOrdersStateModel.fromJson(Map<String, dynamic> json) {
    return PutOrdersStateModel(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),

      // null bo‘lishi mumkin
      acceptedAt: json['accepted_at']?.toString(),
      completedAt: json['completed_at']?.toString(),
      canceledAt: json['canceled_at']?.toString(),

      createdAt: (json['created_at'] ?? '').toString(),
      updatedAt: (json['updated_at'] ?? '').toString(),

      customer: (json['customer'] ?? 0) as int,
      staff: (json['staff'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "address": address,
    "status": status,
    "accepted_at": acceptedAt,
    "completed_at": completedAt,
    "canceled_at": canceledAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "customer": customer,
    "staff": staff,
  };

  static List<PutOrdersStateModel> listFromJson(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(PutOrdersStateModel.fromJson)
          .toList();
    }
    return const [];
  }
}
