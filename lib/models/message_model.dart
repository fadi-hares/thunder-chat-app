import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String userName;
  final String userMessage;
  final String userEmail;
  final String createdAt;
  const MessageModel({
    required this.userName,
    required this.userMessage,
    required this.userEmail,
    required this.createdAt,
  });

  factory MessageModel.initial() => const MessageModel(
        userName: '',
        userMessage: '',
        userEmail: '',
        createdAt: '',
      );

  factory MessageModel.fromDoc(DocumentSnapshot snapshot) {
    final messageData = snapshot.data() as Map<String, dynamic>;
    return MessageModel(
      userName: messageData['userName'],
      userMessage: messageData['message'],
      userEmail: messageData['userEmail'],
      createdAt: messageData['createdAt'],
    );
  }

  @override
  String toString() {
    return 'MessageModel(userName: $userName, userImage: $userMessage, userEmail: $userEmail, createdAt: $createdAt)';
  }

  @override
  List<Object> get props => [userName, userMessage, userEmail, createdAt];
}
