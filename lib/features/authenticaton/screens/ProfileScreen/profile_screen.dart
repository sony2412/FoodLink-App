import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/user_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, this.role = 'donor'});
  final String role;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _orgController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;

  bool _isSaving = false;
  bool _isLocationLoading = false;

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLocationLoading = true);
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
        setState(() {
          _addressController.text = '${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}'.replaceAll(RegExp(r'^, '), '');
        });
      }
    } catch (e) {
      Get.snackbar('Location Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => _isLocationLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _orgController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'FullName': _nameController.text,
        'PhoneNumber': _phoneController.text,
        'OrganizationName': _orgController.text,
        'OrganizationAddress': _addressController.text,
        'Bio': _bioController.text,
      });
      UserController.instance.updateUserData(name: _nameController.text);
    }
    setState(() => _isSaving = false);
    Get.back();
    Get.snackbar(
      'Profile Updated',
      FTexts.profileUpdated,
      backgroundColor: const Color(0xFF1D9E75),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Iconsax.tick_circle, color: Colors.white),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _orgController = TextEditingController();
    _addressController = TextEditingController();
    _bioController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _nameController.text = data['FullName'] ?? '';
        _emailController.text = data['Email'] ?? '';
        _phoneController.text = data['PhoneNumber'] ?? '';
        _orgController.text = data['OrganizationName'] ?? '';
        _addressController.text = data['OrganizationAddress'] ?? '';
        _bioController.text = data['Bio'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: Stack(
        children: [
          // Ambient blobs
          Positioned(
            top: -80, left: -80,
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF0F6E56).withValues(alpha: 0.35),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: 80, right: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFBA7517).withValues(alpha: 0.25),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      FSizzes.defaultSpace, 16, FSizzes.defaultSpace, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(Iconsax.arrow_left,
                              color: Color(0xFF5DCAA5), size: 20),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          FTexts.editProfile,
                          style: TextStyle(
                            color: Color(0xFF9FE1CB),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // Save button in appbar
                      GestureDetector(
                        onTap: _isSaving ? null : _save,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            FTexts.save,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: FSizzes.defaultSpace),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Avatar
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 90, height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF0F6E56), Color(0xFF1D9E75)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      color: const Color(0xFF1D9E75).withValues(alpha: 0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _nameController.text.isNotEmpty ? _nameController.text[0] : 'U',
                                      style: const TextStyle(
                                        color: Color(0xFF9FE1CB),
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0, right: 0,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: 30, height: 30,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color(0xFF0D3D30), width: 2),
                                      ),
                                      child: const Icon(Iconsax.camera,
                                          color: Colors.white, size: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to change photo',
                            style: TextStyle(
                              color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Personal Info Section
                          _SectionLabel(label: 'Personal Information'),
                          const SizedBox(height: 12),

                          _ProfileField(
                            controller: _nameController,
                            label: FTexts.fullName,
                            icon: Iconsax.user,
                            validator: (v) =>
                            v == null || v.isEmpty ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 14),
                          _ProfileField(
                            controller: _emailController,
                            label: FTexts.email,
                            icon: Iconsax.sms,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                            v == null || !v.contains('@') ? 'Enter valid email' : null,
                          ),
                          const SizedBox(height: 14),
                          _ProfileField(
                            controller: _phoneController,
                            label: FTexts.phoneNumber,
                            icon: Iconsax.call,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 24),

                          // Organization Section (shown for donor/recipient)
                          if (widget.role != 'volunteer') ...[
                            _SectionLabel(label: 'Organization Details'),
                            const SizedBox(height: 12),
                            _ProfileField(
                              controller: _orgController,
                              label: widget.role == 'recipient'
                                  ? 'NGO / Shelter Name'
                                  : 'Organization / Restaurant Name',
                              icon: Iconsax.building,
                            ),
                            const SizedBox(height: 14),
                            _ProfileField(
                              controller: _addressController,
                              label: 'Address / Area',
                              icon: Iconsax.location,
                              suffixIcon: IconButton(
                                onPressed: _isLocationLoading ? null : _getCurrentLocation,
                                icon: _isLocationLoading 
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEF9F27)))
                                  : const Icon(Iconsax.gps, color: Color(0xFFEF9F27), size: 20),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Bio Section
                          _SectionLabel(label: 'About'),
                          const SizedBox(height: 12),
                          _ProfileField(
                            controller: _bioController,
                            label: 'Bio',
                            icon: Iconsax.note,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 32),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: GestureDetector(
                              onTap: _isSaving ? null : _save,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFEF9F27)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _isSaving
                                      ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF9FE1CB),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF5DCAA5), size: 20),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 13),
        floatingLabelStyle: const TextStyle(color: Color(0xFF9FE1CB)),
        filled: true,
        fillColor: const Color(0xFF0F6E56).withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D9E75)),
        ),
      ),
    );
  }
}
