import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../repo/chats_repo.dart';

part 'fetch_chat_state.dart';

class FetchChatCubit extends Cubit<FetchChatsState> {
  final ChatRepo chatRepo;
  FetchChatCubit({required this.chatRepo}) : super(FetchChatsState.initial()) {}

  void getSnaps({required String userID}) async {
    // print(userID);
    emit(state.copyWith(fetchChatsStatus: FetchChatsStatus.loading));
    try {
      final snapShots = await chatRepo.fetchChats(userID: userID);
      emit(
        state.copyWith(
          fetchChatsStatus: FetchChatsStatus.loaded,
          docSnapshotList: snapShots!.docs,
        ),
      );
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          customError: e,
          fetchChatsStatus: FetchChatsStatus.error,
        ),
      );
    }
  }
}
