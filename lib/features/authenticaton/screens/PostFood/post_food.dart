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

  // Text controllers
  final foodName = TextEditingController();
  final description = TextEditingController();
  final quantity = TextEditingController();
  final pickupLocation = TextEditingController();
  final pickupInstructions = TextEditingController();

  // Reactive state
  final selectedCategory = ''.obs;
  final selectedUnit = 'kg'.obs;
  final selectedDietaryType = ''.obs;
  final selectedDeliveryOption = 'self_pickup'.obs;
  final expiryDate = Rxn<DateTime>();
  final pickupFrom = Rxn<TimeOfDay>();
  final pickupTo = Rxn<TimeOfDay>();
  final selectedImages = <String>[].obs;
  final isLoading = false.obs;
  final isLocationLoading = false.obs;

  // Options
  final categories = ['Cooked Food', 'Raw Ingredients', 'Bakery', 'Dairy', 'Fruits & Vegetables', 'Packaged Food', 'Beverages', 'Other'];
  final units = ['kg', 'grams', 'litres', 'ml', 'plates', 'boxes', 'packets', 'pieces', 'servings'];
  final dietaryTypes = ['Vegetarian', 'Non-Vegetarian', 'Vegan', 'Gluten-Free', 'Dairy-Free'];

  String get formattedExpiryDate {
    if (expiryDate.value == null) return 'Select date & time';
    final d = expiryDate.value!;
    return '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  String get formattedPickupWindow {
    if (pickupFrom.value == null || pickupTo.value == null) return 'Select time window';
    return '${pickupFrom.value!.format(Get.context!)} – ${pickupTo.value!.format(Get.context!)}';
  }

  Future<void> pickExpiryDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(hours: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (date == null) return;
    final time = await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
    if (time == null) return;
    expiryDate.value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> pickTimeWindow() async {
    final from = await showTimePicker(context: Get.context!, initialTime: const TimeOfDay(hour: 9, minute: 0), helpText: 'Pickup FROM');
    if (from == null) return;
    final to = await showTimePicker(context: Get.context!, initialTime: TimeOfDay(hour: from.hour + 2, minute: from.minute), helpText: 'Pickup TO');
    if (to == null) return;
    pickupFrom.value = from;
    pickupTo.value = to;
  }

  /// TRACK CURRENT LOCATION LOGIC
  Future<void> getCurrentLocation() async {
    try {
      isLocationLoading.value = true;

      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLocationLoading.value = false;
        Get.snackbar('Location Disabled', 'Please enable location services in your settings.',
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      // 2. Check & Request Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLocationLoading.value = false;
          Get.snackbar('Permission Denied', 'Location permissions are required to auto-fill address.',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLocationLoading.value = false;
        Get.snackbar('Permission Restricted', 'Location permissions are permanently denied. Please enable them in settings.',
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      // 3. Get Coordinates
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // 4. Reverse Geocode (Convert Lat/Long to Address)
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Construct readable address
        String address = "${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
        pickupLocation.text = address.replaceAll("null,", "").replaceAll(", null", "");
      }

      isLocationLoading.value = false;
      Get.snackbar('Location Updated', 'Current address has been filled.',
          backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);

    } catch (e) {
      isLocationLoading.value = false;
      Get.snackbar('Error', 'Could not fetch location: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> submitListing() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedCategory.value.isEmpty || selectedDietaryType.value.isEmpty || expiryDate.value == null || pickupFrom.value == null) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      await _db.collection('FoodListings').add({
        'DonorId': user.uid,
        'DonorName': UserController.instance.userName.value,
        'FoodName': foodName.text.trim(),
        'Description': description.text.trim(),
        'Category': selectedCategory.value,
        'DietaryType': selectedDietaryType.value,
        'Quantity': '${quantity.text.trim()} ${selectedUnit.value}',
        'ExpiryDate': Timestamp.fromDate(expiryDate.value!),
        'PickupLocation': pickupLocation.text.trim(),
        'PickupWindow': formattedPickupWindow,
        'DeliveryOption': selectedDeliveryOption.value,
        'Status': 'Available',
        'CreatedAt': FieldValue.serverTimestamp(),
      });

      isLoading.value = false;
      Get.back();
      Get.snackbar('Success', 'Food listing posted successfully!', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
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
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(icon: Iconsax.cake, title: 'Food Information'),
                      const SizedBox(height: 14),
                      FTextField(controller: controller.foodName, label: 'Food Name *', prefixIcon: Iconsax.cake),
                      const SizedBox(height: 14),
                      FTextField(controller: controller.description, label: 'Description', prefixIcon: Iconsax.document_text, maxLines: 3),
                      const SizedBox(height: 14),
                      _SectionLabel(label: 'Category *'),
                      const SizedBox(height: 8),
                      Obx(() => Wrap(
                        spacing: 8, runSpacing: 8,
                        children: controller.categories.map((cat) => _ChipSelect(
                          label: cat, 
                          isSelected: controller.selectedCategory.value == cat,
                          onTap: () => controller.selectedCategory.value = cat,
                        )).toList(),
                      )),
                      const SizedBox(height: 14),
                      _SectionLabel(label: 'Dietary Type *'),
                      const SizedBox(height: 8),
                      Obx(() => Wrap(
                        spacing: 8, runSpacing: 8,
                        children: controller.dietaryTypes.map((type) => _ChipSelect(
                          label: type, 
                          isSelected: controller.selectedDietaryType.value == type,
                          onTap: () => controller.selectedDietaryType.value = type,
                        )).toList(),
                      )),
                      const SizedBox(height: 24),
                      _SectionHeader(icon: Iconsax.weight, title: 'Quantity & Expiry'),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(flex: 2, child: FTextField(controller: controller.quantity, label: 'Quantity *', keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(child: Obx(() => _DropdownUnit(controller: controller))),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _SectionLabel(label: 'Expiry Date *'),
                      const SizedBox(height: 8),
                      Obx(() => _DateTimeTile(label: controller.formattedExpiryDate, icon: Iconsax.calendar, onTap: controller.pickExpiryDate)),
                      const SizedBox(height: 24),
                      _SectionHeader(icon: Iconsax.location, title: 'Pickup Details'),
                      const SizedBox(height: 14),

                      // PICKUP LOCATION WITH TRACK BUTTON
                      FTextField(
                        controller: controller.pickupLocation,
                        label: 'Pickup Address *',
                        prefixIcon: Iconsax.location,
                        suffixIcon: Obx(() => IconButton(
                          onPressed: controller.isLocationLoading.value ? null : controller.getCurrentLocation,
                          icon: controller.isLocationLoading.value 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEF9F27)))
                              : const Icon(Iconsax.gps, color: Color(0xFFEF9F27)),
                          tooltip: 'Track my current location',
                        )),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: controller.getCurrentLocation,
                        child: Row(
                          children: [
                            const Icon(Iconsax.gps, color: Color(0xFF5DCAA5), size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'Track my current location',
                              style: TextStyle(color: const Color(0xFF5DCAA5).withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),
                      _SectionLabel(label: 'Pickup Window *'),
                      const SizedBox(height: 8),
                      Obx(() => _DateTimeTile(label: controller.formattedPickupWindow, icon: Iconsax.clock, onTap: controller.pickTimeWindow)),
                      const SizedBox(height: 32),
                      Obx(() => GestureDetector(
                        onTap: controller.isLoading.value ? null : controller.submitListing,
                        child: Container(
                          width: double.infinity, height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFEF9F27), Color(0xFFBA7517)]),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: controller.isLoading.value 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Post Food Listing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left, color: Color(0xFF5DCAA5))),
          const Text('Post Food', style: TextStyle(color: Color(0xFF9FE1CB), fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon; final String title;
  const _SectionHeader({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: const Color(0xFF5DCAA5), size: 18),
      const SizedBox(width: 10),
      Text(title, style: const TextStyle(color: Color(0xFF9FE1CB), fontWeight: FontWeight.bold)),
    ]);
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Text(label, style: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 13));
  }
}

class _ChipSelect extends StatelessWidget {
  final String label; final bool isSelected; final VoidCallback onTap;
  const _ChipSelect({required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D9E75) : const Color(0xFF0F6E56).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.3)),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF5DCAA5), fontSize: 12)),
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _DateTimeTile({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0F6E56).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.4)),
        ),
        child: Row(children: [
          Icon(icon, color: const Color(0xFF5DCAA5), size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Color(0xFF9FE1CB))),
        ]),
      ),
    );
  }
}

class _DropdownUnit extends StatelessWidget {
  final PostFoodController controller;
  const _DropdownUnit({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedUnit.value,
          dropdownColor: const Color(0xFF0D3D30),
          items: controller.units.map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(color: Color(0xFF9FE1CB))))).toList(),
          onChanged: (v) => controller.selectedUnit.value = v!,
        ),
      ),
    );
  }
}
