import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FoodListing {
  final String id;
  final String foodName;
  final String description;
  final String category;
  final String dietaryType;
  final String quantity;
  final String unit;
  final DateTime expiryDate;
  final String pickupLocation;
  final String pickupFrom;
  final String pickupTo;
  final String pickupInstructions;
  final String deliveryOption;
  final String donorName;
  final String donorType; // 'Restaurant', 'Home', 'Store'
  final double donorRating;
  final int donorDonations;
  final double distanceKm;
  final String status; // 'available', 'claimed', 'expired'
  final List<String> images;

  const FoodListing({
    required this.id,
    required this.foodName,
    required this.description,
    required this.category,
    required this.dietaryType,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.pickupLocation,
    required this.pickupFrom,
    required this.pickupTo,
    required this.pickupInstructions,
    required this.deliveryOption,
    required this.donorName,
    required this.donorType,
    required this.donorRating,
    required this.donorDonations,
    required this.distanceKm,
    required this.status,
    required this.images,
});
}

class FoodDetailController extends GetxController {
  final listing = Rxn<FoodListing>();
  final isSaved = false.obs;
  final isClaiming = false.obs;
  final currentImageIndex = 0.obs;
  final selectedDelivery = 'self_pickup'.obs; // 'self_pickup' | 'volunteer'

  @override
  void onInit() {
    super.onInit();
    //get Listings from backend
    if (Get.arguments != null && Get.arguments is FoodListing) {
      listing.value = Get.arguments as FoodListing;
      // Set default delivery based on listing's delivery option
      if (listing.value!.deliveryOption == 'volunteer') {
        selectedDelivery.value = 'volunteer';
      }
    } else {
      // Mock data for UI testing
      listing.value = FoodListing(
        id: '1',
        foodName: 'Biryani & Dal',
        description: 'Freshly cooked chicken biryani with dal makhani. Made in a clean kitchen. No artificial preservatives. Suitable for 10-12 people. Cooked at 2 PM today.',
        category: 'Cooked Food',
        dietaryType: 'Non-Vegetarian',
        quantity: '15',
        unit: 'plates',
        expiryDate: DateTime.now().add(const Duration(hours: 3)),
        pickupLocation: 'Spice Garden Restaurant, MG Road, Nagpur',
        pickupFrom: '3:00 PM',
        pickupTo: '6:00 PM',
        pickupInstructions: 'Ask for Rahul at the counter. Use side entrance.',
        deliveryOption: 'both',
        donorName: 'Spice Garden Restaurant',
        donorType: 'Restaurant',
        donorRating: 4.8,
        donorDonations: 142,
        distanceKm: 0.8,
        status: 'available',
        images: [],
      );
    }
  }

  String get timeLeftText {
    if (listing.value == null) return '';
    final diff = listing.value!.expiryDate.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inHours < 1) return '${diff.inMinutes}m left';
    if (diff.inHours < 24) return '${diff.inHours}h ${diff.inMinutes.remainder(60)}m left';
    return '${diff.inDays}d left';
  }

  bool get isUrgent {
    if (listing.value == null) return false;
    final diff = listing.value!.expiryDate.difference(DateTime.now());
    return diff.inHours < 3;
  }

  Future<void> claimFood() async {
    isClaiming.value = true;
    // TODO: teammate wires Firestore here
    // await FirebaseFirestore.instance.collection('claims').add({
    //   'listingId': listing.value!.id,
    //   'recipientId': FirebaseAuth.instance.currentUser!.uid,
    //   'deliveryOption': selectedDelivery.value,
    //   'status': 'pending',
    //   'claimedAt': FieldValue.serverTimestamp(),
    // });
    // Also update listing status to 'claimed':
    // await FirebaseFirestore.instance.collection('listings')
    //     .doc(listing.value!.id).update({'status': 'claimed'});
    await Future.delayed(const Duration(seconds: 2));
    isClaiming.value = false;
    _showClaimSuccess();
  }
}

void _showClaimSuccess() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF0D3D30),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.tick_circle, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Food Claimed! 🎉',
              style: TextStyle(
                color: Color(0xFF9FE1CB),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your request has been sent to the donor.\nYou\'ll be notified once approved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // Info row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _DialogStat(icon: Iconsax.clock, label: 'Pickup', value: '3–6 PM'),
                  Container(width: 1, height: 30, color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
                  _DialogStat(icon: Iconsax.location, label: 'Distance', value: '0.8 km'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.back(); // close dialog
                Get.back(); // go back to browse
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'View My Claims',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DialogStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DialogStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF5DCAA5), size: 16),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w600)),
        Text(label, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), fontSize: 10)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  FOOD DETAIL SCREEN
// ─────────────────────────────────────────────
class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodDetailController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: Obx(() {
        final listing = controller.listing.value;
        if (listing == null) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1D9E75)));
        }

        return Stack(
          children: [
            // Ambient blobs
            Positioned(
              top: -60, right: -60,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFFBA7517).withValues(alpha: 0.2),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: 120, left: -40,
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF0F6E56).withValues(alpha: 0.25),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),

            Column(
              children: [
                // ── Image / Header area ──
                _buildImageHeader(controller, listing),

                // ── Scrollable content ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleRow(controller, listing),
                        const SizedBox(height: 16),
                        _buildQuickInfo(listing),
                        const SizedBox(height: 20),
                        _buildDescription(listing),
                        const SizedBox(height: 20),
                        _buildDonorCard(listing),
                        const SizedBox(height: 20),
                        _buildPickupDetails(listing),
                        const SizedBox(height: 20),
                        if (listing.deliveryOption != 'self_pickup')
                          _buildDeliverySelector(controller, listing),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Sticky bottom claim button ──
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildClaimBar(controller, listing),
            ),
          ],
        );
      }),
    );
  }

  // ── IMAGE HEADER ──
  Widget _buildImageHeader(FoodDetailController controller, FoodListing listing) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          // Image placeholder / carousel
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0F6E56).withValues(alpha: 0.4),
                  const Color(0xFF1D9E75).withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: listing.images.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.image,
                  color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                  size: 56,
                ),
                const SizedBox(height: 8),
                Text(
                  listing.category,
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            )
                : PageView.builder(
              itemCount: listing.images.length,
              onPageChanged: (i) => controller.currentImageIndex.value = i,
              itemBuilder: (_, i) => Image.network(
                listing.images[i],
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay bottom
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, const Color(0xFF0D3D30)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 12, left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D3D30).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
                ),
                child: const Icon(Iconsax.arrow_left, color: Color(0xFF5DCAA5), size: 20),
              ),
            ),
          ),

          // Save button
          Positioned(
            top: 12, right: 16,
            child: Obx(() => GestureDetector(
              onTap: () => controller.isSaved.value = !controller.isSaved.value,
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D3D30).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.isSaved.value
                        ? const Color(0xFFEF9F27).withValues(alpha: 0.5)
                        : const Color(0xFF1D9E75).withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  controller.isSaved.value ? Iconsax.heart5 : Iconsax.heart,
                  color: controller.isSaved.value ? const Color(0xFFEF9F27) : const Color(0xFF5DCAA5),
                  size: 20,
                ),
              ),
            )),
          ),

          // Urgent badge
          if (controller.isUrgent)
            Positioned(
              top: 12,
              left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF9F27),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.clock, color: Colors.white, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        'URGENT — ${controller.timeLeftText}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Image dots (if multiple images)
          if (listing.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0, right: 0,
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(listing.images.length, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: controller.currentImageIndex.value == i ? 20 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: controller.currentImageIndex.value == i
                        ? const Color(0xFFEF9F27)
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                )),
              )),
            ),
        ],
      ),
    );
  }

  // ── TITLE ROW ──
  Widget _buildTitleRow(FoodDetailController controller, FoodListing listing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                listing.foodName,
                style: const TextStyle(
                  color: Color(0xFF9FE1CB),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _StatusBadge(
                    label: listing.dietaryType,
                    color: listing.dietaryType == 'Vegetarian' || listing.dietaryType == 'Vegan'
                        ? const Color(0xFF1D9E75)
                        : const Color(0xFFEF9F27),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(label: listing.category, color: const Color(0xFF5DCAA5)),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(() => Text(
              controller.timeLeftText,
              style: TextStyle(
                color: controller.isUrgent ? const Color(0xFFEF9F27) : const Color(0xFF5DCAA5),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            )),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Iconsax.location, color: Color(0xFFEF9F27), size: 13),
                const SizedBox(width: 3),
                Text(
                  '${listing.distanceKm} km away',
                  style: const TextStyle(color: Color(0xFFEF9F27), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ── QUICK INFO CHIPS ──
  Widget _buildQuickInfo(FoodListing listing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickInfoItem(
            icon: Iconsax.weight,
            label: 'Quantity',
            value: '${listing.quantity} ${listing.unit}',
          ),
          _Divider(),
          _QuickInfoItem(
            icon: Iconsax.calendar,
            label: 'Expires',
            value: '${listing.expiryDate.day}/${listing.expiryDate.month}',
          ),
          _Divider(),
          _QuickInfoItem(
            icon: Iconsax.clock,
            label: 'Pickup',
            value: listing.pickupFrom,
          ),
          _Divider(),
          _QuickInfoItem(
            icon: listing.deliveryOption == 'self_pickup'
                ? Iconsax.man
                : listing.deliveryOption == 'volunteer'
                ? Iconsax.truck
                : Iconsax.people,
            label: 'Delivery',
            value: listing.deliveryOption == 'self_pickup'
                ? 'Self'
                : listing.deliveryOption == 'volunteer'
                ? 'Volunteer'
                : 'Both',
          ),
        ],
      ),
    );
  }

  // ── DESCRIPTION ──
  Widget _buildDescription(FoodListing listing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'About this Food'),
        const SizedBox(height: 10),
        Text(
          listing.description,
          style: TextStyle(
            color: const Color(0xFF9FE1CB).withValues(alpha: 0.85),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ── DONOR CARD ──
  Widget _buildDonorCard(FoodListing listing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Donor'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
                  ),
                ),
                child: Center(
                  child: Text(
                    listing.donorName[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.donorName,
                      style: const TextStyle(
                        color: Color(0xFF9FE1CB),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      listing.donorType,
                      style: TextStyle(
                        color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Iconsax.star5, color: Color(0xFFEF9F27), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${listing.donorRating}',
                          style: const TextStyle(
                            color: Color(0xFFEF9F27),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${listing.donorDonations} donations',
                          style: TextStyle(
                            color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Verified badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Iconsax.verify, color: Color(0xFF5DCAA5), size: 12),
                    SizedBox(width: 3),
                    Text(
                      'Verified',
                      style: TextStyle(
                        color: Color(0xFF5DCAA5),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── PICKUP DETAILS ──
  Widget _buildPickupDetails(FoodListing listing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Pickup Details'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              _PickupRow(
                icon: Iconsax.location,
                label: 'Address',
                value: listing.pickupLocation,
              ),
              const SizedBox(height: 12),
              _PickupRow(
                icon: Iconsax.clock,
                label: 'Time Window',
                value: '${listing.pickupFrom} – ${listing.pickupTo}',
              ),
              if (listing.pickupInstructions.isNotEmpty) ...[
                const SizedBox(height: 12),
                _PickupRow(
                  icon: Iconsax.info_circle,
                  label: 'Instructions',
                  value: listing.pickupInstructions,
                ),
              ],
              const SizedBox(height: 14),
              // Map button
              GestureDetector(
                onTap: () {
                  // TODO: Open Google Maps with pickup location
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.35)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.map_1, color: Color(0xFF5DCAA5), size: 16),
                      SizedBox(width: 8),
                      Text(
                        'View on Map',
                        style: TextStyle(
                          color: Color(0xFF5DCAA5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── DELIVERY SELECTOR (only shown if both options available) ──
  Widget _buildDeliverySelector(FoodDetailController controller, FoodListing listing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'How will you get it?'),
        const SizedBox(height: 10),
        Obx(() => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectedDelivery.value = 'self_pickup',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: controller.selectedDelivery.value == 'self_pickup'
                        ? const Color(0xFF1D9E75).withValues(alpha: 0.2)
                        : const Color(0xFF0F6E56).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: controller.selectedDelivery.value == 'self_pickup'
                          ? const Color(0xFF1D9E75)
                          : const Color(0xFF1D9E75).withValues(alpha: 0.2),
                      width: controller.selectedDelivery.value == 'self_pickup' ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.man,
                        color: controller.selectedDelivery.value == 'self_pickup'
                            ? const Color(0xFF5DCAA5)
                            : const Color(0xFF5DCAA5).withValues(alpha: 0.4),
                        size: 24,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Self Pickup',
                        style: TextStyle(
                          color: controller.selectedDelivery.value == 'self_pickup'
                              ? const Color(0xFF9FE1CB)
                              : const Color(0xFF9FE1CB).withValues(alpha: 0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectedDelivery.value = 'volunteer',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: controller.selectedDelivery.value == 'volunteer'
                        ? const Color(0xFF1D9E75).withValues(alpha: 0.2)
                        : const Color(0xFF0F6E56).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: controller.selectedDelivery.value == 'volunteer'
                          ? const Color(0xFF1D9E75)
                          : const Color(0xFF1D9E75).withValues(alpha: 0.2),
                      width: controller.selectedDelivery.value == 'volunteer' ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.truck,
                        color: controller.selectedDelivery.value == 'volunteer'
                            ? const Color(0xFF5DCAA5)
                            : const Color(0xFF5DCAA5).withValues(alpha: 0.4),
                        size: 24,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Volunteer',
                        style: TextStyle(
                          color: controller.selectedDelivery.value == 'volunteer'
                              ? const Color(0xFF9FE1CB)
                              : const Color(0xFF9FE1CB).withValues(alpha: 0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
        const SizedBox(height: 20),
      ],
    );
  }

  // ── STICKY CLAIM BAR ──
  Widget _buildClaimBar(FoodDetailController controller, FoodListing listing) {
    final isExpired = listing.status == 'expired' ||
        listing.expiryDate.isBefore(DateTime.now());
    final isClaimed = listing.status == 'claimed';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: const Color(0xFF0D3D30),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        if (isExpired) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: const Center(
              child: Text(
                'This listing has expired',
                style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        if (isClaimed) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEF9F27).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEF9F27).withValues(alpha: 0.3)),
            ),
            child: const Center(
              child: Text(
                'Already claimed by someone',
                style: TextStyle(color: Color(0xFFEF9F27), fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: controller.isClaiming.value ? null : controller.claimFood,
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
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: controller.isClaiming.value
                  ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5,
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.heart, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Claim This Food',
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
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
//  REUSABLE WIDGETS
// ─────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF9FE1CB),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _QuickInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _QuickInfoItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF5DCAA5), size: 18),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF9FE1CB),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, height: 36,
      color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
    );
  }
}

class _PickupRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PickupRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF5DCAA5), size: 15),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF9FE1CB),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}