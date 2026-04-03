import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/homescreen/donor_home.dart';
import '../screens/homescreen/recipitent_home.dart';
import '../screens/homescreen/volunteer_home.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  /// Login logic
  Future<void> login(String role) async {
    try {
      // Start Loading
      isLoading.value = true;

      // TODO: Firebase Authentication
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      // Simulate Firebase call
      await Future.delayed(const Duration(seconds: 2));

      // Stop Loading
      isLoading.value = false;

      // Navigate based on role
      switch (role) {
        case 'donor':
          Get.offAll(() => const DonorDashboard());
          break;
        case 'recipient':
          Get.offAll(() => const RecipientDashboard());
          break;
        case 'volunteer':
          Get.offAll(() => const VolunteerDashboard());
          break;
        default:
          Get.offAll(() => const DonorDashboard());
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
