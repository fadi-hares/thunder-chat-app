part of 'users_cubit.dart';

enum UserStatus {
  initail,
  loading,
  loaded,
  error,
}

class UsersState extends Equatable {
  final UserStatus userStatus;
  final List<UserModel> usersList;
  final UserModel loggedUser;
  final CustomError customError;
  const UsersState({
    required this.loggedUser,
    required this.userStatus,
    required this.usersList,
    required this.customError,
  });

  factory UsersState.initail() => UsersState(
        loggedUser: UserModel.initial(),
        userStatus: UserStatus.initail,
        usersList: [],
        customError: CustomError(),
      );

  @override
  List<Object> get props => [userStatus, usersList, loggedUser, customError];

  @override
  String toString() {
    return 'UsersState(userStatus: $userStatus, usersList: $usersList, loggedUser: $loggedUser, customError: $customError)';
  }

  UsersState copyWith({
    UserStatus? userStatus,
    List<UserModel>? usersList,
    UserModel? loggedUser,
    CustomError? customError,
  }) {
    return UsersState(
      userStatus: userStatus ?? this.userStatus,
      usersList: usersList ?? this.usersList,
      loggedUser: loggedUser ?? this.loggedUser,
      customError: customError ?? this.customError,
    );
  }
}
