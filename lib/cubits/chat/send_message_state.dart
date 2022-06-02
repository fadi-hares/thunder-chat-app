part of 'send_message_cubit.dart';

enum SendMessageStatus {
  initial,
  sending,
  sent,
  error,
}

class SendMessageState extends Equatable {
  final SendMessageStatus sendMessageStatus;
  final CustomError customError;
  const SendMessageState({
    required this.sendMessageStatus,
    required this.customError,
  });

  factory SendMessageState.initail() => const SendMessageState(
        sendMessageStatus: SendMessageStatus.initial,
        customError: CustomError(),
      );

  @override
  List<Object> get props => [sendMessageStatus, customError];

  SendMessageState copyWith({
    SendMessageStatus? chatStatus,
    CustomError? customError,
  }) {
    return SendMessageState(
      sendMessageStatus: chatStatus ?? sendMessageStatus,
      customError: customError ?? this.customError,
    );
  }

  @override
  String toString() =>
      'SendMessageState(sendMessageStatus: $sendMessageStatus, customError: $customError)';
}
