part of 'signup_cubit.dart';

enum SignupStatus {
  initial,
  submitting,
  success,
  error,
}

class SignupState extends Equatable {
  final SignupStatus signupStatus;
  final CustomError customError;
  const SignupState({
    required this.signupStatus,
    required this.customError,
  });

  factory SignupState.initial() => const SignupState(
      signupStatus: SignupStatus.initial, customError: CustomError());

  @override
  List<Object> get props => [signupStatus, customError];

  @override
  String toString() =>
      'SignupState(signupStatus: $signupStatus, customError: $customError)';

  SignupState copyWith({
    SignupStatus? signupStatus,
    CustomError? customError,
  }) {
    return SignupState(
      signupStatus: signupStatus ?? this.signupStatus,
      customError: customError ?? this.customError,
    );
  }
}
