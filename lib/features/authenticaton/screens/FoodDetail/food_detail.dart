import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodListing {
  final String id;
  final String foodName;
  final String description;
  final String category;
  final String dietaryType;
  final String quantity;
  final DateTime expiryDate;
  final String pickupLocation;
  final String pickupFrom;
  final String pickupTo;
  final String pickupInstructions;
  final String deliveryOption;
  final String donorName;
  final String status;
  final List<String> images;

  const FoodListing({
    required this.id, required this.foodName, required this.description, required this.category,
    required this.dietaryType, required this.quantity, required this.expiryDate,
    required this.pickupLocation, required this.pickupFrom, required this.pickupTo,
    required this.pickupInstructions, required this.deliveryOption, required this.donorName,
    required this.status, required this.images,
  });
}

class FoodDetailController extends GetxController {
  final listing = Rxn<FoodListing>();
  final isSaved = false.obs;
  final isClaiming = false.obs;
  final currentImageIndex = 0.obs;
  final selectedDelivery = 'self_pickup'.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      final Map<String, dynamic> data = Get.arguments;
      listing.value = FoodListing(
        id: '',
        foodName: data['FoodName'] ?? '',
        description: data['Description'] ?? 'No description provided.',
        category: data['Category'] ?? '',
        dietaryType: data['DietaryType'] ?? '',
        quantity: data['Quantity'] ?? '',
        expiryDate: (data['ExpiryDate'] != null) ? (data['ExpiryDate']).toDate() : DateTime.now(),
        pickupLocation: data['PickupLocation'] ?? '',
        pickupFrom: data['PickupWindow']?.split('–').first ?? '',
        pickupTo: data['PickupWindow']?.split('–').last ?? '',
        pickupInstructions: '',
        deliveryOption: data['DeliveryOption'] ?? 'both',
        donorName: data['DonorName'] ?? 'Unknown Donor',
        status: data['Status'] ?? 'Available',
        images: [],
      );
    }
  }

  /// OPEN GOOGLE MAPS WITH ADDRESS
  Future<void> openMap() async {
    final address = listing.value?.pickupLocation;
    if (address == null || address.isEmpty) return;

    final encodedAddress = Uri.encodeComponent(address);
    final googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
    
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open Google Maps.');
    }
  }

  String get timeLeftText {
    if (listing.value == null) return '';
    final diff = listing.value!.expiryDate.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inHours < 1) return '${diff.inMinutes}m left';
    return '${diff.inHours}h ${diff.inMinutes.remainder(60)}m left';
  }

  bool get isUrgent => listing.value != null && listing.value!.expiryDate.difference(DateTime.now()).inHours < 3;

  Future<void> claimFood() async {
    isClaiming.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isClaiming.value = false;
    Get.snackbar('Success', 'Food claimed successfully!', backgroundColor: Colors.green, colorText: Colors.white);
    Get.back();
  }
}

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodDetailController());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FScreenBackground(
        child: Obx(() {
          final listing = controller.listing.value;
          if (listing == null) return const Center(child: CircularProgressIndicator());

          return Stack(
            children: [
              Column(children: [
                _buildHeader(controller, listing),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _buildTitle(controller, listing),
                      const SizedBox(height: 24),
                      _buildDescription(listing),
                      const SizedBox(height: 24),
                      _buildPickupSection(controller, listing),
                    ]),
                  ),
                ),
              ]),
              Positioned(bottom: 0, left: 0, right: 0, child: _buildClaimBar(controller)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(FoodDetailController controller, FoodListing listing) {
    return Container(
      height: 240, width: double.infinity,
      color: const Color(0xFF0F6E56).withOpacity(0.1),
      child: Stack(children: [
        const Center(child: Icon(Iconsax.image, color: Color(0xFF1D9E75), size: 64)),
        Positioned(top: 40, left: 16, child: IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left, color: Colors.white))),
      ]),
    );
  }

  Widget _buildTitle(FoodDetailController controller, FoodListing listing) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(listing.foodName, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(children: [
        _Badge(label: listing.category, color: const Color(0xFFEF9F27)),
        const SizedBox(width: 10),
        _Badge(label: listing.dietaryType, color: const Color(0xFF1D9E75)),
      ]),
    ]);
  }

  Widget _buildDescription(FoodListing listing) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Description', style: TextStyle(color: Color(0xFF9FE1CB), fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(listing.description, style: TextStyle(color: const Color(0xFF5DCAA5).withOpacity(0.8), height: 1.5)),
    ]);
  }

  Widget _buildPickupSection(FoodDetailController controller, FoodListing listing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF0F6E56).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Pickup Location', style: TextStyle(color: Color(0xFF9FE1CB), fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Iconsax.location, color: Color(0xFFEF9F27), size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(listing.pickupLocation, style: const TextStyle(color: Color(0xFF5DCAA5)))),
        ]),
        const SizedBox(height: 20),
        
        /// GOOGLE MAPS BUTTON
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.openMap,
            icon: const Icon(Iconsax.map_1),
            label: const Text('View on Google Maps'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF9F27),
              side: const BorderSide(color: Color(0xFFEF9F27)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildClaimBar(FoodDetailController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF0D3D30),
      child: ElevatedButton(
        onPressed: controller.claimFood,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF9F27), minimumSize: const Size(double.infinity, 56)),
        child: const Text('Claim This Food', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label; final Color color;
  const _Badge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.5))),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
