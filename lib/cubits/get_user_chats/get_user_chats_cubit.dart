import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_model.dart';
import '../../models/custom_error.dart';
import '../../repo/chats_repo.dart';
import '../fetch_chat/fetch_chat_cubit.dart';

part 'get_user_chats_state.dart';

class GetUserChatsCubit extends Cubit<GetUserChatsState> {
  late StreamSubscription fetchChatSub;

  final ChatRepo chatRepo;
  final FetchChatCubit fetchChatCubit;

  GetUserChatsCubit({
    required this.chatRepo,
    required this.fetchChatCubit,
  }) : super(GetUserChatsState.initil());

  void getUserChats({required String userID}) {
    fetchChatSub = fetchChatCubit.stream.listen((fetchChatState) async {
      if (fetchChatState.docSnapshotList.isNotEmpty) {
        emit(state.copyWith(getUserChatsStatus: GetUserChatsStatus.loading));
        try {
          final List<ChatModel> chatList = [];
          final List<QuerySnapshot> snapshotList =
              await chatRepo.getLastUsersMessage(
            loggedUserID: userID,
            snapshotList: fetchChatState.docSnapshotList,
          );
          for (var snapShot in snapshotList) {
            final lastMessage = snapShot.docs[0];
            final data = lastMessage.data() as Map<String, dynamic>;
            final ChatModel chatModel = ChatModel.fromDoc(lastMessage: data);
            chatList.add(chatModel);
            emit(
              state.copyWith(
                chatsList: chatList,
                getUserChatsStatus: GetUserChatsStatus.loaded,
              ),
            );
            // print('chats list: ${state.chatsList}');
          }
        } on CustomError catch (e) {
          emit(
            state.copyWith(
              customError: e,
              getUserChatsStatus: GetUserChatsStatus.error,
            ),
          );
        }
      } else {
        emit(state.copyWith(chatsList: []));
      }
    });
  }
}
