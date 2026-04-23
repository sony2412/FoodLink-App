import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:foodlink/common/widgets/f_text_field.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../controllers/user_controller.dart';

class PostFoodController extends GetxController {
  static PostFoodController get instance => Get.find();

  final formKey = GlobalKey<FormState>();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final foodName = TextEditingController();
  final description = TextEditingController();
  final quantity = TextEditingController();
  final pickupLocation = TextEditingController();

  final selectedCategory = 'Cooked Food'.obs;
  final selectedUnit = 'kg'.obs;
  final selectedDietaryType = 'Vegetarian'.obs;
  final expiryDate = Rxn<DateTime>();
  final isLoading = false.obs;
  final isLocationLoading = false.obs;

  final categories = ['Cooked Food', 'Raw Ingredients', 'Bakery', 'Dairy', 'Fruits & Vegetables', 'Packaged Food', 'Beverages', 'Other'];
  final units = ['kg', 'grams', 'litres', 'ml', 'plates', 'boxes', 'packets', 'pieces', 'servings'];

  String get formattedExpiryDate => expiryDate.value == null ? 'Select date' : "${expiryDate.value!.day}/${expiryDate.value!.month}/${expiryDate.value!.year}";

  Future<void> pickExpiryDate() async {
    final date = await showDatePicker(
      context: Get.context!, 
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime.now().add(const Duration(days: 7))
    );
    if (date != null) expiryDate.value = date;
  }

  Future<void> getCurrentLocation() async {
    try {
      isLocationLoading.value = true;
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLocationLoading.value = false;
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        pickupLocation.text = "${placemarks[0].name}, ${placemarks[0].locality}";
      }
      isLocationLoading.value = false;
    } catch (e) {
      isLocationLoading.value = false;
      Get.snackbar('Error', 'Location failed: $e');
    }
  }

  Future<void> submitListing() async {
    if (!formKey.currentState!.validate() || expiryDate.value == null) {
      if (expiryDate.value == null) Get.snackbar('Error', 'Please select an expiry date');
      return;
    }
    try {
      isLoading.value = true;
      await _db.collection('FoodListings').add({
        'DonorId': _auth.currentUser?.uid,
        'DonorName': UserController.instance.userName.value,
        'FoodName': foodName.text.trim(),
        'Description': description.text.trim(),
        'Category': selectedCategory.value,
        'Quantity': "${quantity.text.trim()} ${selectedUnit.value}",
        'PickupLocation': pickupLocation.text.trim(),
        'ExpiryDate': Timestamp.fromDate(expiryDate.value!),
        'Status': 'Available',
        'CreatedAt': FieldValue.serverTimestamp(),
      });
      isLoading.value = false;
      Get.back();
      Get.snackbar('Success', 'Food Posted Successfully!', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Post failed: $e');
    }
  }
}

class PostFoodScreen extends StatelessWidget {
  const PostFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostFoodController());
    return FScreenBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent, 
            elevation: 0,
            leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left, color: Colors.white)),
            title: const Text('Post Food', style: TextStyle(color: Color(0xFF9FE1CB)))
          ),
          body: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FTextField(controller: controller.foodName, label: 'Food Name', prefixIcon: Iconsax.cake, validator: (v) => v == null || v.isEmpty ? 'Food name is required' : null),
                  const SizedBox(height: 15),
                  FTextField(controller: controller.description, label: 'Description', prefixIcon: Iconsax.document_text, maxLines: 3, validator: (v) => v == null || v.isEmpty ? 'Description is required' : null),
                  const SizedBox(height: 15),
                  const Text('Category', style: TextStyle(color: Color(0xFF5DCAA5), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Obx(() => Wrap(
                    spacing: 8, 
                    children: controller.categories.map((c) => ChoiceChip(
                      label: Text(c, style: TextStyle(color: controller.selectedCategory.value == c ? Colors.white : const Color(0xFF5DCAA5))), 
                      selected: controller.selectedCategory.value == c, 
                      selectedColor: const Color(0xFF1D9E75),
                      backgroundColor: const Color(0xFF0F6E56).withOpacity(0.1),
                      onSelected: (s) => controller.selectedCategory.value = c,
                    )).toList()
                  )),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: FTextField(controller: controller.quantity, label: 'Qty', prefixIcon: Iconsax.weight, keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: const Color(0xFF0F6E56).withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.3))),
                        child: Obx(() => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedUnit.value, 
                            dropdownColor: const Color(0xFF0D3D30),
                            items: controller.units.map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(color: Color(0xFF9FE1CB))))).toList(), 
                            onChanged: (v) => controller.selectedUnit.value = v!
                          ),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text('Expiry Date', style: TextStyle(color: Color(0xFF5DCAA5), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Obx(() => ListTile(
                    title: Text(controller.formattedExpiryDate, style: const TextStyle(color: Colors.white)), 
                    leading: const Icon(Iconsax.calendar, color: Color(0xFF5DCAA5)), 
                    onTap: controller.pickExpiryDate, 
                    tileColor: const Color(0xFF0F6E56).withOpacity(0.1), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: const Color(0xFF1D9E75).withOpacity(0.3)))
                  )),
                  const SizedBox(height: 15),
                  const Text('Pickup Location', style: TextStyle(color: Color(0xFF5DCAA5), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FTextField(
                    controller: controller.pickupLocation, 
                    label: 'Address', 
                    prefixIcon: Iconsax.location,
                    validator: (v) => v == null || v.isEmpty ? 'Pickup location is required' : null,
                    suffixIcon: Obx(() => IconButton(
                      onPressed: controller.isLocationLoading.value ? null : controller.getCurrentLocation, 
                      icon: controller.isLocationLoading.value 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEF9F27))) 
                        : const Icon(Iconsax.gps, color: Color(0xFFEF9F27))
                    )),
                  ),
                  const SizedBox(height: 30),
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.submitListing, 
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF9F27), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), 
                    child: controller.isLoading.value 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Post Food Listing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
