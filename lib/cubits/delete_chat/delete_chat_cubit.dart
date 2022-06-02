import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thunder_chat_app/models/custom_error.dart';
import 'package:thunder_chat_app/repo/chats_repo.dart';

part 'delete_chat_state.dart';

class DeleteChatCubit extends Cubit<DeleteChatState> {
  final ChatRepo chatRepo;
  DeleteChatCubit({required this.chatRepo}) : super(DeleteChatState.initial());

  Future<void> deleteChat({
    required String id,
    required String reciverID,
  }) async {
    emit(state.copyWith(deleteChatStatus: DeleteChatStatus.deleting));
    try {
      await chatRepo.deleteChat(id: id, reciverID: reciverID);
      emit(state.copyWith(deleteChatStatus: DeleteChatStatus.deleted));
    } on CustomError catch (e) {
      emit(state.copyWith(
          customError: e, deleteChatStatus: DeleteChatStatus.error));
    }
  }
}
