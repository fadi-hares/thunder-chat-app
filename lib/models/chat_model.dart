import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String userID;
  final String email;
  final String imageUrl;
  final String name;
  final String lastMessage;

  const ChatModel({
    required this.userID,
    required this.email,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
  });

  factory ChatModel.fromDoc({
    required Map<String, dynamic> lastMessage,
  }) {
    return ChatModel(
      userID: lastMessage['reciverID'],
      email: lastMessage['reciverEmail'],
      imageUrl: lastMessage['reciverImage'],
      name: lastMessage['reciverName'],
      lastMessage: lastMessage['message'],
    );
  }

  factory ChatModel.initial() => const ChatModel(
        userID: '',
        email: '',
        imageUrl: '',
        name: '',
        lastMessage: '',
      );

  @override
  List<Object> get props => [email, imageUrl, name, lastMessage];

  @override
  String toString() {
    return 'ChatModel(id: $email, imageUrl: $imageUrl, name: $name, lastMessage: $lastMessage)';
  }
}
