import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thunder_chat_app/const/db_const.dart';
import 'package:thunder_chat_app/models/custom_error.dart';
import 'package:thunder_chat_app/models/user_models.dart';

class UsersRepo {
  Future<List<UserModel>> getUsres() async {
    List<UserModel> usersList = [];
    try {
      final users = await userRef.get();
      for (var e in users.docs) {
        usersList.add(UserModel.fromDoc(e));
      }
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
    return usersList;
  }

  Future<UserModel> getOneUser({required String userID}) async {
    try {
      final user = await userRef.doc(userID).get();

      return UserModel.fromDoc(user);
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }
}
