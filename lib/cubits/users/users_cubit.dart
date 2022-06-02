import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thunder_chat_app/models/custom_error.dart';
import 'package:thunder_chat_app/models/user_models.dart';
import 'package:thunder_chat_app/repo/users_repo.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepo usersRepo;
  UsersCubit({required this.usersRepo}) : super(UsersState.initail());

  Future<void> getUsers() async {
    emit(state.copyWith(userStatus: UserStatus.loading));
    try {
      final users = await usersRepo.getUsres();
      emit(state.copyWith(userStatus: UserStatus.loaded, usersList: users));
    } on CustomError catch (e) {
      emit(state.copyWith(customError: e, userStatus: UserStatus.error));
    }
  }

  Future<void> getOneUser({required String userID}) async {
    emit(state.copyWith(userStatus: UserStatus.loading));
    try {
      final user = await usersRepo.getOneUser(userID: userID);
      print(user.userName);
      emit(state.copyWith(userStatus: UserStatus.loaded, loggedUser: user));
    } on CustomError catch (e) {
      emit(state.copyWith(customError: e, userStatus: UserStatus.error));
    }
  }
}
