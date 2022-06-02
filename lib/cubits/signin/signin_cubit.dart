import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thunder_chat_app/models/custom_error.dart';
import 'package:thunder_chat_app/repo/auth_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepo authRepo;

  SigninCubit({required this.authRepo}) : super(SigninState.initial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(signinStatus: SigninStatus.submitting));
    try {
      await authRepo.singIn(email: email, password: password);
      emit(state.copyWith(signinStatus: SigninStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(customError: e, signinStatus: SigninStatus.error));
    }
  }
}
