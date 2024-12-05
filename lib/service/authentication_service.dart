import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_online_shop/model/authentication_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grocery_online_shop/view/widgets/user_bottom_bar.dart';

class AuthenticationService {
  String collection = 'user';
  late CollectionReference<UserModel> users;
  String? verificationid;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Reference storage = FirebaseStorage.instance.ref();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  AuthenticationService() {
    users = FirebaseFirestore.instance
        .collection(collection)
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJson(
          snapshot.data()!,
        );
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

  Future<void> addUser(UserModel data) async {
    try {
      await users.doc(firebaseAuth.currentUser!.uid).set(data);
    } catch (e) {
      log('error during adding user data:$e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final snapshot = await fireStore
        .collection(collection)
        .doc(firebaseAuth.currentUser?.uid)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      return UserModel.fromJson(
        snapshot.data()!,
      );
    } else {
      return null;
    }
  }

  Future<UserCredential> userEmailCreate(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      log('Account created');
      return userCredential;
    } catch (error) {
      log('error during creating account :$error ');
      rethrow;
    }
  }

  Future<UserCredential> userEmailSignIn(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      log('signed in');
      return userCredential;
    } on FirebaseAuthMultiFactorException catch (error) {
      throw Exception(error.code);
    }
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  Future<UserModel?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        log('Google authentication failed');
        throw Exception('Google authentication failed');
      }

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? gUser = userCredential.user;

      if (gUser != null) {
        final user = UserModel(
          image: gUser.photoURL ?? '',
          uId: gUser.uid,
          userName: gUser.displayName ?? '',
          email: gUser.email ?? '',
          phoneNumber: gUser.phoneNumber ?? '',
        );
        return user;
      } else {
        log('Google user is null');
        return null;
      }
    } catch (error) {
      log('Google SignIn error : $error');
      rethrow;
    }
  }

  Future googleSignOut() async {
    return await GoogleSignIn().signOut();
  }

  Future<void> getOtp(String phoneNumber) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await user.updatePhoneNumber(phoneAuthCredential);
          }
        },
        verificationFailed: (error) {
          log("verification failed error : $error");
        },
        codeSent: (verificationId, forceResendingToken) {
          verificationid = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verificationid = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      log("error during generating otp: $e");
    }
  }

  Future<PhoneAuthCredential?> verifyOtp(
      otp, context, Function? snackBarError) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationid!, smsCode: otp);
      await firebaseAuth.signInWithCredential(credential);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const UserBottomBar(),
          ),
          (route) => false);
    } catch (e) {
      snackBarError;
      log("otp verification error $e");
      return null;
    }
    return null;
  }

  void passwordReset(
      {required String email,
      context,
      required Function(String) onError,
      required Function(String) success}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      log('password reset link sent');
      success('password reset link is sent to email');
    } on FirebaseAuthException catch (e) {
      log('error occured during reset password');
      onError(e.message.toString());
    }
  }

  updateUser(userid, UserModel data) async {
    try {
      await users.doc(userid).update(
            data.toJson(),
          );
    } catch (e) {
      log("error in updating user :$e");
    }
  }

  Future<String> uploadImage(imageName, imageFile) async {
    Reference imageFolder = storage.child('profileImage');
    Reference? uploadImage = imageFolder.child('$imageName.jpg');

    await uploadImage.putFile(imageFile);
    String downloadURL = await uploadImage.getDownloadURL();
    log('Image successfully uploaded to Firebase Storage.');
    return downloadURL;
  }

  Future<List<UserModel>> getAllUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await fireStore.collection(collection).get();

      List<UserModel> data = snapshot.docs
          .map(
            (e) => UserModel.fromJson(
              e.data(),
            ),
          )
          .toList();
      return data;
    } catch (e) {
      log('getAllUser error: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await fireStore.collection(collection).doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromJson(snapshot.data()!);
      } else {
        log('User not found with ID: $userId');
        return null;
      }
    } catch (e) {
      log('Error fetching user by ID: $e');
      return null;
    }
  }
}
