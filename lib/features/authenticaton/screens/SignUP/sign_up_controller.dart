import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../emailVerification/verify_email.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final signupFormKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final isLoading = false.obs;

  Future<void> signup(String role) async {
    try {
      if (!signupFormKey.currentState!.validate()) return;
      isLoading.value = true;

      // 1. Create Auth Account
      // Firebase will handle the registration. 
      // Testing email like "+1@gmail.com" might be blocked if 'Email enumeration protection' is ON in Firebase Console.
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // 2. We store a temporary "Pending" state or just hold off on specific features.
      // Standard practice: Add user to DB but with 'isVerified: false'
      await _db.collection("Users").doc(userCredential.user!.uid).set({
        'FullName': fullName.text.trim(),
        'Email': email.text.trim().toLowerCase(),
        'PhoneNumber': phoneNumber.text.trim(),
        'Role': role.toLowerCase(),
        'isVerified': false, // NEW: track verification status
        'CreatedAt': FieldValue.serverTimestamp(),
      });

      isLoading.value = false;
      Get.to(() => const VerifyEmailScreen());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Registration Failed', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    fullName.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
