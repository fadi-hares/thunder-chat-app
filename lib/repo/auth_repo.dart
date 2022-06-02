import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thunder_chat_app/const/db_const.dart';
import 'package:thunder_chat_app/models/custom_error.dart';

class AuthRepo {
  final ImagePicker imagePicker;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;
  AuthRepo({
    required this.imagePicker,
    required this.firebaseStorage,
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  Stream<User?> get user => firebaseAuth.userChanges();

  Future<String?> pickImage() async {
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 150,
    );
    if (image != null) {
      return image.path;
    } else {
      return null;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String? imagePath,
  }) async {
    try {
      if (imagePath == null) {
        throw 'Please pick an image first';
      }
      final UserCredential user = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final userImagesRef = storageRef.child(user.user!.uid + 'jpg');
      final image = File(imagePath);
      await userImagesRef.putFile(image);

      final String imageUrl = await userImagesRef.getDownloadURL();
      await userRef.doc(user.user!.uid).set({
        'name': name,
        'email': email,
        'image': imageUrl,
      });
    } on FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        message: e.toString(),
      );
    }
  }

  Future<void> singIn({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Error',
        message: e.toString(),
        plugin: 'flutter-error',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Error',
        message: e.toString(),
        plugin: 'flutter-error',
      );
    }
  }
}
