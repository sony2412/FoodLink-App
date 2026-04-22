import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../successScreen/success_screen.dart';

class MailController extends GetxController {
  static MailController get instance => Get.find();

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedirect();
  }

  /// Send Verification Email
  Future<void> sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } catch (e) {
      Get.snackbar('Email Error', 'Please use a valid Gmail address. Fake emails won\'t receive verification links.');
    }
  }

  /// Set Timer for auto redirect
  void setTimerForAutoRedirect() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      
      if (user?.emailVerified ?? false) {
        timer.cancel();
        
        // 1. Update verification status in Firestore
        await FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({
          'isVerified': true,
        });

        // 2. Redirect to Success
        Get.offAll(() => const SuccessScreen());
      }
    });
  }

  /// Manually Check status
  void checkEmailVerificationStatus() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
        'isVerified': true,
      });
      Get.offAll(() => const SuccessScreen());
    } else {
      Get.snackbar('Not Verified', 'Please click the link in your email first.');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
