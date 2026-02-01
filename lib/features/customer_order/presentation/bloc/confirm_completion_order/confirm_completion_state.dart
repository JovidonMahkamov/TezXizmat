
abstract class ConfirmCompletionState {
  const ConfirmCompletionState();
}

class ConfirmCompletionInitial extends ConfirmCompletionState {}

class ConfirmCompletionLoading extends ConfirmCompletionState {}

class ConfirmCompletionSuccess extends ConfirmCompletionState {

  const ConfirmCompletionSuccess();
}

class ConfirmCompletionError extends ConfirmCompletionState {
  final String message;

  const ConfirmCompletionError({required this.message});
}
