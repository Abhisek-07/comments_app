import 'dart:developer';

import 'package:comments_app/utils/app_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state.g.dart';

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> build() {
    return _firebaseAuth.authStateChanges();
  }

  // Sign up with email and password
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    String message = '';
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("User signed up: ${userCredential.user?.uid}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        log('An account already exists for that email.');
        message = 'An account already exists for that email.';
      }
      AppHelper.showAlert(message: message);
      return null;
    } catch (e) {
      log("Sign up error: $e");
      AppHelper.showAlert(message: "Failed: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    String? message;
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("User signed in: ${userCredential.user?.uid}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        message = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided.');
        message = "No user found for that email";
      }
      AppHelper.showAlert(message: message ?? "Please enter valid credentials");
      return null;
    } catch (e) {
      log("Sign in error: $e");
      AppHelper.showAlert(message: "Failed $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      log('User signed out');
    } catch (e) {
      log("Sign out error: $e");
    }
  }

  // Check if user is signed in
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  // Listen to auth state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
