part of 'signin_cubit.dart';

enum SigninStatus {
  initial,
  submitting,
  success,
  error,
}

class SigninState extends Equatable {
  final SigninStatus signinStatus;
  final CustomError customError;
  const SigninState({
    required this.signinStatus,
    required this.customError,
  });

  factory SigninState.initial() => const SigninState(
      signinStatus: SigninStatus.initial, customError: CustomError());

  @override
  List<Object> get props => [signinStatus, customError];

  @override
  String toString() =>
      'SigninState(signinStatus: $signinStatus, customError: $customError)';

  SigninState copyWith({
    SigninStatus? signinStatus,
    CustomError? customError,
  }) {
    return SigninState(
      signinStatus: signinStatus ?? this.signinStatus,
      customError: customError ?? this.customError,
    );
  }
}
