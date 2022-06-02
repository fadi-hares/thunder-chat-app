import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String userID;
  final String userName;
  final String userImage;
  final String userEmail;
  const UserModel({
    required this.userID,
    required this.userName,
    required this.userImage,
    required this.userEmail,
  });

  factory UserModel.initial() =>
      const UserModel(userName: '', userImage: '', userEmail: '', userID: '');

  factory UserModel.fromDoc(DocumentSnapshot snapshot) {
    final userData = snapshot.data() as Map<String, dynamic>?;
    return UserModel(
      userID: snapshot.id,
      userName: userData!['name'],
      userImage: userData['image'],
      userEmail: userData['email'],
    );
  }

  @override
  List<Object> get props => [userName, userImage, userEmail, userID];

  @override
  String toString() =>
      'UserModel(userName: $userName, userImage: $userImage, userEmail: $userEmail, userEmail: $userID)';
}
