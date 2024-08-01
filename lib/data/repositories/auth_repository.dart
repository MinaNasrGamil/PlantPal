import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../models/user_model.dart';

class AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;

  AuthRepository({firebase.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;
  var currentUser = User.empty;
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

  Future<void> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (userCredential) {
          userCredential.user!.updateDisplayName(username);
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'user name': username,
          });
        },
      );
    } on firebase.FirebaseAuthException catch (error) {
      print('Error from AuthRepository: ${error.message}');
      rethrow;
    }
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on firebase.FirebaseAuthException catch (error) {
      print('Error from AuthRepository: ${error.message}');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (e) {}
  }

  bool isVerified() {
    bool verified = firebase.FirebaseAuth.instance.currentUser!.emailVerified;
    print('email check $verified');
    if (verified) {
      reloadCurrentUser();
    }
    return verified;
  }

  Future<void> sendEmailVerification() async {
    try {
      await firebase.FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (_) {}
  }

  Future<void> reloadCurrentUser() async {
    final firebaseUser = firebase.FirebaseAuth.instance
        .currentUser; // Get the current Firebase User instance
    if (firebaseUser != null) {
      await firebaseUser.reload(); // Call reload on the Firebase User instance
      final isVerified = firebaseUser.emailVerified;

      // Update your custom User object with the new verification status
      currentUser = currentUser.copyWith(isVerified: isVerified);
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (error) {
      print('Error from AuthRepository: ${error.message}');
      rethrow;
    }
  }
}

extension on firebase.User {
  User get toUser {
    return User(
        id: uid,
        email: email,
        name: displayName,
        photo: photoURL,
        isVerified: emailVerified);
  }
}
