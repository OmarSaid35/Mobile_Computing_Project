import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _user;

  UserModel? get user => _user;

  // Sign-up method using Firebase Authentication and Firestore

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required DateTime birthDate,
    required String schoolName,
  }) async {
    try {
      // Create a new user with FirebaseAuth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID from FirebaseAuth
      String userId = userCredential.user!.uid;

      // Store additional user information (like name, birthDate, schoolName, id, and isAdmin)
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'id': userId,
        'email': email,
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'schoolName': schoolName,
        'isAdmin': false,
      });

      notifyListeners();
    } catch (e) {
      throw e; // Handle errors (e.g., email already in use, weak password)
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        _user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }

      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  void autoLogin() async {
    // Changed to synchronous method
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      await signIn(email: email, password: password, rememberMe: false);
    }
  }

  // Helper method to handle Firebase Auth errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for this email. Please check the email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'weak-password':
        return 'The password is too short. Please choose a longer password.';
      case 'email-already-in-use':
        return 'This email is already registered. Please try logging in or reset your password.';
      case 'invalid-email':
        return 'The email address is not valid. Please check the email format.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'user-disabled':
        return 'Your account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'invalid-credential':
        return 'Wrong email or password. Please try again';
      default:
        return 'Authentication failed. Please try again later.';
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('password');

      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (error) {
      print('Error during sign out: $error');
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw 'No user is currently signed in.';
      }

      await user.updatePassword(newPassword);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'password': newPassword,
      });

      print('Password updated successfully.');
    } catch (e) {
      throw 'Failed to update password: $e';
    }
  }
}
