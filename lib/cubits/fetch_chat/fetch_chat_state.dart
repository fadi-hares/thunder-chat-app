part of 'fetch_chat_cubit.dart';

enum FetchChatsStatus {
  initial,
  loading,
  loaded,
  error,
}

class FetchChatsState extends Equatable {
  final FetchChatsStatus fetchChatsStatus;
  final CustomError customError;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docSnapshotList;
  const FetchChatsState({
    required this.fetchChatsStatus,
    required this.customError,
    required this.docSnapshotList,
  });

  factory FetchChatsState.initial() {
    return const FetchChatsState(
      fetchChatsStatus: FetchChatsStatus.initial,
      customError: CustomError(),
      docSnapshotList: [],
    );
  }

  @override
  List<Object?> get props => [fetchChatsStatus, customError, docSnapshotList];

  @override
  String toString() =>
      'FetchChatsState(fetchChatsStatus: $fetchChatsStatus, customError: $customError, docSnapshot: $docSnapshotList)';

  FetchChatsState copyWith({
    FetchChatsStatus? fetchChatsStatus,
    CustomError? customError,
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? docSnapshotList,
  }) {
    return FetchChatsState(
      fetchChatsStatus: fetchChatsStatus ?? this.fetchChatsStatus,
      customError: customError ?? this.customError,
      docSnapshotList: docSnapshotList ?? this.docSnapshotList,
    );
  }
}
