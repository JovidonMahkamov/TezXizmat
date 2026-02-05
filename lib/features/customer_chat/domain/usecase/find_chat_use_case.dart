import 'package:tez_xizmat/features/customer_chat/domain/entities/find_chat_entity.dart';
import 'package:tez_xizmat/features/customer_chat/domain/repositories/chat_repository.dart';

class FindChatUseCase {
  final ChatRepository repo;

  FindChatUseCase(this.repo);

  Future<FindChatEntity> call({
    required int staff_id,
    required int customer_id,
    required int order_id,
  }) async {
    return await repo.findChat(
      staff_id: staff_id,
      customer_id: customer_id,
      order_id: order_id,
    );
  }
}
