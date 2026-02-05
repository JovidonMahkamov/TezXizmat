import 'package:tez_xizmat/features/customer_chat/data/model/find_chat_model.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/find_chat_entity.dart';


abstract class FindChatState  {
  const FindChatState();
}

class FindChatInitial extends FindChatState {
  const FindChatInitial();
}

class FindChatLoading extends FindChatState {
  const FindChatLoading();
}

class FindChatSuccess extends FindChatState {
  final FindChatEntity findChatEntity;

  const FindChatSuccess(this.findChatEntity);
}

class FindChatError extends FindChatState {
  final String message;

  const FindChatError(this.message);
}
