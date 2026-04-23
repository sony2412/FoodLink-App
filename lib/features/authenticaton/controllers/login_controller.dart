import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_controller.dart';
import '../screens/homescreen/donor_home.dart';
import '../screens/homescreen/recipitent_home.dart';
class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  final userController = UserController.instance;

  /// Email/Password Login
  Future<void> login() async {
    try {
      if (!loginFormKey.currentState!.validate()) return;
      isLoading.value = true;

      // 1. Firebase Auth Login
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // 2. Fetch data from Firestore
      final userDoc = await _db.collection("Users").doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        
        final String dbRole = (userData['Role'] ?? '').toString().trim().toLowerCase();
        final String dbName = userData['FullName'] ?? 'User';

        // 3. Set Session
        userController.updateUserData(
          name: dbName, 
          email: email.text.trim(), 
          role: dbRole
        );

        isLoading.value = false;
        
        // 4. Navigate to the correct dashboard automatically based on DB role
        _navigateToDashboard(dbRole);

      } else {
        isLoading.value = false;
        await _auth.signOut();
        Get.snackbar('Error', 'User profile not found. Please register first.', snackPosition: SnackPosition.BOTTOM);
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = e.message ?? "Authentication Error";
      Get.snackbar('Login Error', message, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Google Login
  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut(); 
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc = await _db.collection("Users").doc(user.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final String dbRole = (userData['Role'] ?? 'recipient').toString().trim().toLowerCase();
          final String dbName = userData['FullName'] ?? user.displayName ?? 'User';

          userController.updateUserData(name: dbName, email: user.email ?? '', role: dbRole);
          isLoading.value = false;
          _navigateToDashboard(dbRole);
        } else {
          isLoading.value = false;
          await _auth.signOut();
          await googleSignIn.signOut();
          Get.snackbar('Registration Required', 'Account exists but no role is assigned. Please sign up first.', snackPosition: SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Google Login Failed', 'Error: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _navigateToDashboard(String role) {
    if (role.contains('donor')) {
      Get.offAll(() => const DonorDashboard());
    } else if (role.contains('recipient')) {
      Get.offAll(() => const RecipientDashboard());
    } else {
      // Default fallback
      Get.offAll(() => const RecipientDashboard());
    }
  }
}
