abstract class ChatDeleteState {
  const ChatDeleteState();
}

class  ChatDeleteInitial extends ChatDeleteState {}

class  ChatDeleteLoading extends ChatDeleteState {}

class ChatDeleteSuccess extends ChatDeleteState {
  final int deletedCount;
  const ChatDeleteSuccess({required this.deletedCount});
}


class  ChatDeleteError extends ChatDeleteState {
  final String message;

  const  ChatDeleteError({required this.message});
}
