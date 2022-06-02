import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thunder_chat_app/const/db_const.dart';
import 'package:thunder_chat_app/models/custom_error.dart';

class ChatRepo {
  Future<void> deleteChat({
    required String id,
    required String reciverID,
  }) async {
    try {
      await messageRef.doc(id).collection('user-chats').doc(reciverID).delete();
      await messageRef.doc(reciverID).collection('user-chats').doc(id).delete();
      await chatsRef.doc(id).collection('IDS').doc(reciverID).delete();
      await chatsRef.doc(reciverID).collection('IDS').doc(id).delete();
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

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
    try {
      await messageRef
          .doc(senderID)
          .collection('user-chats')
          .doc(reciverID)
          .collection('messages')
          .doc()
          .set({
        'senderID': senderID,
        'reciverID': reciverID,
        'senderEmail': senderEmail,
        'reciverEmail': reciverEmail,
        'senderImage': senderImage,
        'reciverImage': reciverImage,
        'senderName': senderName,
        'reciverName': reciverName,
        'message': message,
        'createdAt': DateTime.now(),
      });
      await messageRef
          .doc(reciverID)
          .collection('user-chats')
          .doc(senderID)
          .collection('messages')
          .doc()
          .set({
        'senderID': senderID,
        'reciverID': reciverID,
        'senderEmail': senderEmail,
        'reciverEmail': reciverEmail,
        'senderImage': senderImage,
        'reciverImage': reciverImage,
        'senderName': senderName,
        'reciverName': reciverName,
        'message': message,
        'createdAt': DateTime.now(),
      });
      await chatsRef.doc(senderID).collection('IDS').doc(reciverID).set({
        'reciverID': reciverID,
      });
      await chatsRef.doc(reciverID).collection('IDS').doc(senderID).set({
        'reciverID': senderID,
      });
    } on FirebaseException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages({
    required String userID,
    required String reciverID,
  }) async* {
    try {
      yield* messageRef
          .doc(userID)
          .collection('user-chats')
          .doc(reciverID)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> fetchChats(
      {required String userID}) async {
    try {
      final snapshot = await chatsRef.doc(userID).collection('IDS').get();
      return snapshot;
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<List<QuerySnapshot<Map<String, dynamic>>>> getLastUsersMessage({
    required String loggedUserID,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshotList,
  }) async {
    // print('user ID: ${loggedUserID}');

    List<QuerySnapshot<Map<String, dynamic>>> chats = [];

    for (var snapshot in snapshotList) {
      final lastMessage = await messageRef
          .doc(loggedUserID)
          .collection('user-chats')
          .doc(snapshot.id)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .get();

      // print('chats list: ${lastMessage.docs[0].data()}');
      chats.add(lastMessage);
    }
    return chats;
  }
}
