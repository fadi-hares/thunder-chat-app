import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thunder_chat_app/models/custom_error.dart';
import 'package:thunder_chat_app/repo/chats_repo.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  final ChatRepo chatRepo;
  SendMessageCubit({required this.chatRepo})
      : super(SendMessageState.initail());
  Future<void> sendMessage({
    required String senderID,
    required String reciverID,
    required String senderEmail,
    required String reciverEmail,
    required String senderImage,
    required String reciverImage,
    required String senderName,
    required String reciverName,
    required String message,
  }) async {
    emit(state.copyWith(chatStatus: SendMessageStatus.sending));
    try {
      await chatRepo.sendMessage(
        senderID: senderID,
        reciverID: reciverID,
        senderEmail: senderEmail,
        reciverEmail: reciverEmail,
        senderImage: senderImage,
        reciverImage: reciverImage,
        senderName: senderName,
        reciverName: reciverName,
        message: message,
      );
      emit(state.copyWith(chatStatus: SendMessageStatus.sent));
    } on CustomError catch (e) {
      emit(state.copyWith(customError: e, chatStatus: SendMessageStatus.error));
    }
  }
}
