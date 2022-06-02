part of 'auth_cubit.dart';

enum AuthStatus {
  unknow,
  authenticated,
  unAuthenticated,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final User? user;
  const AuthState({
    required this.authStatus,
    this.user,
  });

  factory AuthState.initial() => const AuthState(authStatus: AuthStatus.unknow);

  @override
  List<Object?> get props => [authStatus, user];

  @override
  String toString() => 'AuthState(authStatus: $authStatus, user: $user)';

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }
}
