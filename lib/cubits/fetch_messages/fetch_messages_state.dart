part of 'fetch_messages_cubit.dart';

enum MessagesStatus {
  initil,
  loading,
  loaded,
  error,
}

// ignore: must_be_immutable
class FetchMessagesState extends Equatable {
  final MessagesStatus messagesStatus;
  final CustomError customError;
  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchMessages;
  FetchMessagesState({
    this.fetchMessages,
    required this.messagesStatus,
    required this.customError,
  });

  factory FetchMessagesState.initail() {
    return FetchMessagesState(
      messagesStatus: MessagesStatus.initil,
      customError: const CustomError(),
    );
  }

  @override
  List<Object?> get props => [messagesStatus, customError, fetchMessages];

  FetchMessagesState copyWith({
    MessagesStatus? messagesStatus,
    CustomError? customError,
    Stream<QuerySnapshot<Map<String, dynamic>>>? fetchMessages,
  }) {
    return FetchMessagesState(
      messagesStatus: messagesStatus ?? this.messagesStatus,
      customError: customError ?? this.customError,
      fetchMessages: fetchMessages ?? this.fetchMessages,
    );
  }

  @override
  String toString() =>
      'FetchMessagesState(messagesStatus: $messagesStatus, customError: $customError, fetchMessages: $fetchMessages)';
}
