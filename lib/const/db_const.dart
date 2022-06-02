import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final messageRef = FirebaseFirestore.instance.collection('chats');
final chatsRef = FirebaseFirestore.instance.collection('user-chats');
final storageRef = FirebaseStorage.instance.ref().child('users-images');
