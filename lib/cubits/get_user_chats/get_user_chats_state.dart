part of 'get_user_chats_cubit.dart';

enum GetUserChatsStatus {
  initial,
  loading,
  loaded,
  error,
}

class GetUserChatsState extends Equatable {
  final GetUserChatsStatus getUserChatsStatus;
  final CustomError customError;
  final List<ChatModel> chatsList;
  const GetUserChatsState({
    required this.getUserChatsStatus,
    required this.customError,
    required this.chatsList,
  });

  factory GetUserChatsState.initil() {
    return const GetUserChatsState(
      getUserChatsStatus: GetUserChatsStatus.initial,
      customError: CustomError(),
      chatsList: [],
    );
  }

  @override
  List<Object> get props => [getUserChatsStatus, customError, chatsList];

  @override
  String toString() =>
      'GetUserChatsState(getUserChatsStatus: $getUserChatsStatus, customError: $customError, chatsList: $chatsList)';

  GetUserChatsState copyWith({
    GetUserChatsStatus? getUserChatsStatus,
    CustomError? customError,
    List<ChatModel>? chatsList,
  }) {
    return GetUserChatsState(
      getUserChatsStatus: getUserChatsStatus ?? this.getUserChatsStatus,
      customError: customError ?? this.customError,
      chatsList: chatsList ?? this.chatsList,
    );
  }
}
