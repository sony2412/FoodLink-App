import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../emailVerification/verify_email.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  /// Form key
  final signupFormKey = GlobalKey<FormState>();

  /// Text controllers
  final fullName        = TextEditingController();
  final email           = TextEditingController();
  final phoneNumber     = TextEditingController();
  final password        = TextEditingController();
  final confirmPassword = TextEditingController();

  /// Reactive toggles & loading states
  final hidePassword        = true.obs;
  final hideConfirmPassword = true.obs;
  final isLoading           = false.obs;
  final isGoogleLoading     = false.obs;
  final isFacebookLoading   = false.obs;

  /// Main signup method
  Future<void> signup() async {
    if (!signupFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // TODO: replace with your auth call e.g. Firebase
      // await AuthenticationRepository.instance
      //     .registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      await Future.delayed(const Duration(seconds: 2)); // placeholder

      isLoading.value = false;


      Get.offAll(() => const VerifyEmailScreen());

    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Sign Up Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  /// Google signup
  Future<void> googleSignUp() async {
    try {
      isGoogleLoading.value = true;
      // TODO: Google auth
      await Future.delayed(const Duration(seconds: 1));
      isGoogleLoading.value = false;
    } catch (e) {
      isGoogleLoading.value = false;
    }
  }

  /// Facebook signup
  Future<void> facebookSignUp() async {
    try {
      isFacebookLoading.value = true;
      // TODO: Facebook auth
      await Future.delayed(const Duration(seconds: 1));
      isFacebookLoading.value = false;
    } catch (e) {
      isFacebookLoading.value = false;
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