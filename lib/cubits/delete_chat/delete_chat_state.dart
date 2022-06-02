part of 'delete_chat_cubit.dart';

enum DeleteChatStatus {
  initial,
  deleting,
  deleted,
  error,
}

class DeleteChatState extends Equatable {
  final DeleteChatStatus deleteChatStatus;
  final CustomError customError;
  DeleteChatState({
    required this.deleteChatStatus,
    required this.customError,
  });

  factory DeleteChatState.initial() => DeleteChatState(
        deleteChatStatus: DeleteChatStatus.initial,
        customError: CustomError(),
      );

  @override
  List<Object> get props => [deleteChatStatus, customError];

  @override
  String toString() =>
      'DeleteChatState(deleteChatStatus: $deleteChatStatus, customError: $customError)';

  DeleteChatState copyWith({
    DeleteChatStatus? deleteChatStatus,
    CustomError? customError,
  }) {
    return DeleteChatState(
      deleteChatStatus: deleteChatStatus ?? this.deleteChatStatus,
      customError: customError ?? this.customError,
    );
  }
}
