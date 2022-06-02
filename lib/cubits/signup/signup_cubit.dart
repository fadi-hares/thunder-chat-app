import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thunder_chat_app/repo/auth_repo.dart';

import '../../models/custom_error.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo authRepo;
  SignupCubit({required this.authRepo}) : super(SignupState.initial());

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String? imagePath,
  }) async {
    emit(state.copyWith(signupStatus: SignupStatus.submitting));

    try {
      await authRepo.signUp(
          email: email, password: password, name: name, imagePath: imagePath);
      emit(state.copyWith(signupStatus: SignupStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(signupStatus: SignupStatus.error, customError: e));
    }
  }
}
