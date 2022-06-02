import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thunder_chat_app/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late StreamSubscription authSubscription;
  final AuthRepo authRepo;

  AuthCubit({required this.authRepo}) : super(AuthState.initial()) {
    authSubscription = authRepo.user.listen((event) {
      if (event != null) {
        emit(state.copyWith(user: event, authStatus: AuthStatus.authenticated));
      } else {
        emit(
            state.copyWith(user: null, authStatus: AuthStatus.unAuthenticated));
      }
    });
  }

  Future<void> signOut() async {
    await authRepo.signOut();
  }
}
