import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:thunder_chat_app/models/custom_error.dart';
import 'package:thunder_chat_app/repo/chats_repo.dart';

part 'fetch_messages_state.dart';

class FetchMessagesCubit extends Cubit<FetchMessagesState> {
  final ChatRepo chatRepo;
  FetchMessagesCubit({required this.chatRepo})
      : super(FetchMessagesState.initail());

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessage({
    required String userID,
    required String reciverID,
  }) async* {
    emit(state.copyWith(messagesStatus: MessagesStatus.loading));
    try {
      yield* chatRepo.getMessages(userID: userID, reciverID: reciverID);
      emit(state.copyWith(messagesStatus: MessagesStatus.loaded));
    } on CustomError catch (e) {
      emit(
          state.copyWith(messagesStatus: MessagesStatus.error, customError: e));
    }
  }
}
