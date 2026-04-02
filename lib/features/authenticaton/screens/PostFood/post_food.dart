import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class PostFoodController extends GetxController {
  static PostFoodController get instance => Get.find();

  final formKey = GlobalKey<FormState>();

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
  final selectedDeliveryOption = 'self_pickup'.obs; // 'self_pickup' | 'volunteer' | 'both'
  final expiryDate = Rxn<DateTime>();
  final pickupFrom = Rxn<TimeOfDay>();
  final pickupTo = Rxn<TimeOfDay>();
  final selectedImages = <String>[].obs; // Will hold image paths
  final isLoading = false.obs;
  final currentStep = 0.obs; // For multi-step form: 0=basic, 1=details, 2=pickup

  // Options
  final categories = [
    'Cooked Food',
    'Raw Ingredients',
    'Bakery',
    'Dairy',
    'Fruits & Vegetables',
    'Packaged Food',
    'Beverages',
    'Other',
  ];

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
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1D9E75),
            onPrimary: Colors.white,
            surface: Color(0xFF0D3D30),
            onSurface: Color(0xFF9FE1CB),
          ),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1D9E75),
            onPrimary: Colors.white,
            surface: Color(0xFF0D3D30),
            onSurface: Color(0xFF9FE1CB),
          ),
        ),
        child: child!,
      ),
    );
    if (time == null) return;
    expiryDate.value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> pickTimeWindow() async {
    final from = await showTimePicker(
      context: Get.context!,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Pickup FROM',
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1D9E75),
            onPrimary: Colors.white,
            surface: Color(0xFF0D3D30),
            onSurface: Color(0xFF9FE1CB),
          ),
        ),
        child: child!,
      ),
    );
    if (from == null) return;
    final to = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay(hour: from.hour + 2, minute: from.minute),
      helpText: 'Pickup TO',
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1D9E75),
            onPrimary: Colors.white,
            surface: Color(0xFF0D3D30),
            onSurface: Color(0xFF9FE1CB),
          ),
        ),
        child: child!,
      ),
    );
    if (to == null) return;
    pickupFrom.value = from;
    pickupTo.value = to;
  }

  bool validateAndSubmit() {
    if (!formKey.currentState!.validate()) return false;
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Missing Field', 'Please select a food category',
          backgroundColor: const Color(0xFF0D3D30),
          colorText: const Color(0xFF9FE1CB));
      return false;
    }
    if (selectedDietaryType.value.isEmpty) {
      Get.snackbar('Missing Field', 'Please select dietary type',
          backgroundColor: const Color(0xFF0D3D30),
          colorText: const Color(0xFF9FE1CB));
      return false;
    }
    if (expiryDate.value == null) {
      Get.snackbar('Missing Field', 'Please set expiry date & time',
          backgroundColor: const Color(0xFF0D3D30),
          colorText: const Color(0xFF9FE1CB));
      return false;
    }
    if (pickupFrom.value == null || pickupTo.value == null) {
      Get.snackbar('Missing Field', 'Please set pickup time window',
          backgroundColor: const Color(0xFF0D3D30),
          colorText: const Color(0xFF9FE1CB));
      return false;
    }
    return true;
  }

  Future<void> submitListing() async {
    if (!validateAndSubmit()) return;
    isLoading.value = true;
    // TODO: Your teammate wires Firebase Firestore here
    // await FirebaseFirestore.instance.collection('listings').add({...})
    //   'foodName': foodName.text,
    //   'description': description.text,
    //   'category': selectedCategory.value,
    //   'dietaryType': selectedDietaryType.value,
    //   'quantity': quantity.text,
    //   'unit': selectedUnit.value,
    //   'expiryDate': expiryDate.value,
    //   'pickupLocation': pickupLocation.text,
    //   'pickupFrom': pickupFrom.value.toString(),
    //   'pickupTo': pickupTo.value.toString(),
    //   'pickupInstructions': pickupInstructions.text,
    //   'deliveryOption': selectedDeliveryOption.value,
    //   'donorId': FirebaseAuth.instance.currentUser!.uid,
    //   'status': 'available',
    //   'createdAt': FieldValue.serverTimestamp(),
    // });
    await Future.delayed(const Duration(seconds: 2)); // mock delay
    isLoading.value = false;
    Get.back();
    Get.snackbar(
      '🎉 Listing Posted!',
      'Your food listing is now live. Recipients can claim it.',
      backgroundColor: const Color(0xFF0F6E56),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    foodName.dispose();
    description.dispose();
    quantity.dispose();
    pickupLocation.dispose();
    pickupInstructions.dispose();
    super.onClose();
  }
}

class PostFoodScreen extends StatelessWidget {
  const PostFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostFoodController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: Stack(
        children: [
          // Ambient blobs
          Positioned(
            top: -60, left: -60,
            child: Container(
              width: 200, height: 200,
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
            bottom: 120, right: -40,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFBA7517).withValues(alpha: 0.2),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── SECTION 1: Food Info ──
                          _SectionHeader(icon: Iconsax.cake, title: 'Food Information'),
                          const SizedBox(height: 14),

                          // Food name
                          _DarkField(
                            controller: controller.foodName,
                            label: 'Food Name *',
                            hint: 'e.g. Biryani, Fresh Vegetables...',
                            icon: Iconsax.cake,
                            validator: (v) => v == null || v.isEmpty ? 'Food name is required' : null,
                          ),
                          const SizedBox(height: 14),

                          // Description
                          _DarkField(
                            controller: controller.description,
                            label: 'Description',
                            hint: 'Any details about the food, allergies, how it was stored...',
                            icon: Iconsax.document_text,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 14),

                          // Category dropdown
                          _SectionLabel(label: 'Category *'),
                          const SizedBox(height: 8),
                          Obx(() => Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.categories.map((cat) {
                              final isSelected = controller.selectedCategory.value == cat;
                              return GestureDetector(
                                onTap: () => controller.selectedCategory.value = cat,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(colors: [Color(0xFFEF9F27), Color(0xFFBA7517)])
                                        : null,
                                    color: isSelected ? null : const Color(0xFF0F6E56).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : const Color(0xFF1D9E75).withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFF5DCAA5),
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                          const SizedBox(height: 14),

                          // Dietary type
                          _SectionLabel(label: 'Dietary Type *'),
                          const SizedBox(height: 8),
                          Obx(() => Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.dietaryTypes.map((type) {
                              final isSelected = controller.selectedDietaryType.value == type;
                              return GestureDetector(
                                onTap: () => controller.selectedDietaryType.value = type,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF1D9E75).withValues(alpha: 0.25)
                                        : const Color(0xFF0F6E56).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF1D9E75)
                                          : const Color(0xFF1D9E75).withValues(alpha: 0.25),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected) ...[
                                        const Icon(Iconsax.tick_circle, color: Color(0xFF5DCAA5), size: 13),
                                        const SizedBox(width: 5),
                                      ],
                                      Text(
                                        type,
                                        style: TextStyle(
                                          color: isSelected ? const Color(0xFF5DCAA5) : const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                          const SizedBox(height: 24),

                          // ── SECTION 2: Quantity & Expiry ──
                          _SectionHeader(icon: Iconsax.weight, title: 'Quantity & Expiry'),
                          const SizedBox(height: 14),

                          // Quantity + unit row
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _DarkField(
                                  controller: controller.quantity,
                                  label: 'Quantity *',
                                  hint: '0',
                                  icon: Iconsax.weight,
                                  keyboardType: TextInputType.number,
                                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: controller.selectedUnit.value,
                                      dropdownColor: const Color(0xFF0D3D30),
                                      style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13),
                                      iconEnabledColor: const Color(0xFF5DCAA5),
                                      items: controller.units.map((u) => DropdownMenuItem(
                                        value: u,
                                        child: Text(u),
                                      )).toList(),
                                      onChanged: (v) => controller.selectedUnit.value = v!,
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Expiry date & time
                          _SectionLabel(label: 'Best Before / Expiry *'),
                          const SizedBox(height: 8),
                          Obx(() => GestureDetector(
                            onTap: controller.pickExpiryDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: controller.expiryDate.value != null
                                      ? const Color(0xFF1D9E75)
                                      : const Color(0xFF1D9E75).withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Iconsax.calendar, color: Color(0xFF5DCAA5), size: 18),
                                  const SizedBox(width: 10),
                                  Text(
                                    controller.formattedExpiryDate,
                                    style: TextStyle(
                                      color: controller.expiryDate.value != null
                                          ? const Color(0xFF9FE1CB)
                                          : const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Iconsax.arrow_right_3,
                                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.4),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          )),
                          const SizedBox(height: 24),

                          // ── SECTION 3: Photos ──
                          _SectionHeader(icon: Iconsax.image, title: 'Photos'),
                          const SizedBox(height: 8),
                          Text(
                            'Add photos to help recipients know what to expect',
                            style: TextStyle(
                              color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(() => SizedBox(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                // Add photo button
                                GestureDetector(
                                  onTap: () {
                                    // TODO: image_picker integration
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                                        width: 1.5,
                                        // dashed style approximation
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Iconsax.camera, color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), size: 28),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Add Photo',
                                          style: TextStyle(
                                            color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Show selected images
                                ...controller.selectedImages.map((path) => Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: const Color(0xFF0F6E56),
                                  ),
                                  child: const Icon(Iconsax.image, color: Color(0xFF5DCAA5)),
                                )),
                              ],
                            ),
                          )),
                          const SizedBox(height: 24),

                          // ── SECTION 4: Pickup Details ──
                          _SectionHeader(icon: Iconsax.location, title: 'Pickup Details'),
                          const SizedBox(height: 14),

                          // Pickup location
                          _DarkField(
                            controller: controller.pickupLocation,
                            label: 'Pickup Address *',
                            hint: 'Street address or landmark',
                            icon: Iconsax.location,
                            validator: (v) => v == null || v.isEmpty ? 'Pickup address is required' : null,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // TODO: Open map picker
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(Iconsax.map, color: Color(0xFFEF9F27), size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Pickup time window
                          _SectionLabel(label: 'Pickup Time Window *'),
                          const SizedBox(height: 8),
                          Obx(() => GestureDetector(
                            onTap: controller.pickTimeWindow,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (controller.pickupFrom.value != null)
                                      ? const Color(0xFF1D9E75)
                                      : const Color(0xFF1D9E75).withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Iconsax.clock, color: Color(0xFF5DCAA5), size: 18),
                                  const SizedBox(width: 10),
                                  Text(
                                    controller.formattedPickupWindow,
                                    style: TextStyle(
                                      color: controller.pickupFrom.value != null
                                          ? const Color(0xFF9FE1CB)
                                          : const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Iconsax.arrow_right_3,
                                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.4),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          )),
                          const SizedBox(height: 14),

                          // Pickup instructions
                          _DarkField(
                            controller: controller.pickupInstructions,
                            label: 'Pickup Instructions (Optional)',
                            hint: 'e.g. Ask for Rahul at the counter, Ring bell 2nd floor...',
                            icon: Iconsax.info_circle,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 24),

                          // ── SECTION 5: Delivery Option ──
                          _SectionHeader(icon: Iconsax.truck, title: 'Delivery Option'),
                          const SizedBox(height: 8),
                          Text(
                            'How can recipients get this food?',
                            style: TextStyle(
                              color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(() => Column(
                            children: [
                              _DeliveryOptionCard(
                                icon: Iconsax.man,
                                title: 'Self Pickup',
                                subtitle: 'Recipient comes to your location',
                                value: 'self_pickup',
                                selected: controller.selectedDeliveryOption.value,
                                onTap: () => controller.selectedDeliveryOption.value = 'self_pickup',
                              ),
                              const SizedBox(height: 10),
                              _DeliveryOptionCard(
                                icon: Iconsax.truck,
                                title: 'Volunteer Delivery',
                                subtitle: 'A FoodLink volunteer picks up & delivers',
                                value: 'volunteer',
                                selected: controller.selectedDeliveryOption.value,
                                onTap: () => controller.selectedDeliveryOption.value = 'volunteer',
                              ),
                              const SizedBox(height: 10),
                              _DeliveryOptionCard(
                                icon: Iconsax.people,
                                title: 'Both Options',
                                subtitle: 'Let recipients or volunteers pick it up',
                                value: 'both',
                                selected: controller.selectedDeliveryOption.value,
                                onTap: () => controller.selectedDeliveryOption.value = 'both',
                              ),
                            ],
                          )),
                          const SizedBox(height: 32),

                          // ── SUBMIT BUTTON ──
                          Obx(() => GestureDetector(
                            onTap: controller.isLoading.value ? null : controller.submitListing,
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEF9F27).withValues(alpha: 0.35),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                  width: 22, height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5,
                                  ),
                                )
                                    : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.send_2, color: Colors.white, size: 18),
                                    SizedBox(width: 10),
                                    Text(
                                      'Post Food Listing',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(height: 12),

                          // Save as draft
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () => Get.snackbar('Draft Saved', 'Your listing has been saved as draft',
                                  backgroundColor: const Color(0xFF0F6E56), colorText: Colors.white),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF5DCAA5),
                              ),
                              child: const Text(
                                'Save as Draft',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
              ),
              child: const Icon(Iconsax.arrow_left, color: Color(0xFF5DCAA5), size: 20),
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post Food',
                style: TextStyle(
                  color: Color(0xFF9FE1CB),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Share your surplus food',
                style: TextStyle(
                  color: Color(0xFF5DCAA5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF5DCAA5), size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF9FE1CB),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF5DCAA5),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const _DarkField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Color(0xFFE8FBF4), fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 13),
        hintStyle: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.4), fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF5DCAA5), size: 18),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF0F6E56).withValues(alpha: 0.15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5DCAA5), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

class _DeliveryOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _DeliveryOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1D9E75).withValues(alpha: 0.15)
              : const Color(0xFF0F6E56).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1D9E75)
                : const Color(0xFF1D9E75).withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1D9E75).withValues(alpha: 0.25)
                    : const Color(0xFF0F6E56).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF5DCAA5) : const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF9FE1CB) : const Color(0xFF9FE1CB).withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1D9E75) : const Color(0xFF1D9E75).withValues(alpha: 0.3),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF1D9E75) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}