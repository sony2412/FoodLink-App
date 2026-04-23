import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../emailVerification/verify_email.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final signupFormKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final organizationName = TextEditingController();
  final organizationAddress = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final isLoading = false.obs;
  final isLocationLoading = false.obs;

  final userType = 'Individual'.obs; // Default. Dynamic based on role

  Future<void> getCurrentLocation() async {
    try {
      isLocationLoading.value = true;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Location services are disabled.';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw 'Location permissions are denied';
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      } 

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        organizationAddress.text = '${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}'.replaceAll(RegExp(r'^, '), '');
      }
    } catch (e) {
      Get.snackbar('Location Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLocationLoading.value = false;
    }
  }

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
        'UserType': userType.value,
        'OrganizationName': organizationName.text.trim(),
        'Address': organizationAddress.text.trim(),
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
    organizationName.dispose();
    organizationAddress.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
