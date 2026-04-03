import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
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
    if (Get.arguments != null && Get.arguments is FoodListing) {
      listing.value = Get.arguments as FoodListing;
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF0D3D30),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF9F27).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Iconsax.tick_circle, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),
            const Text(
              'Food Claimed! 🎉',
              style: TextStyle(
                color: Color(0xFF9FE1CB),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your request has been sent to the donor.\nYou\'ll be notified once approved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _DialogStat(icon: Iconsax.clock, label: 'Pickup', value: '3–6 PM'),
                  Container(width: 1, height: 36, color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
                  _DialogStat(icon: Iconsax.location, label: 'Distance', value: '0.8 km'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.back();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'View My Claims',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
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
        Icon(icon, color: const Color(0xFF5DCAA5), size: 18),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 14, fontWeight: FontWeight.w600)),
        Text(label, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), fontSize: 11)),
      ],
    );
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
          if (listing == null) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1D9E75)));
          }

          return Stack(
            children: [
              Column(
                children: [
                  _buildImageHeader(controller, listing),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleRow(controller, listing),
                          const SizedBox(height: 20),
                          _buildQuickInfo(listing),
                          const SizedBox(height: 24),
                          _buildDescription(listing),
                          const SizedBox(height: 24),
                          _buildDonorCard(listing),
                          const SizedBox(height: 24),
                          _buildPickupDetails(listing),
                          const SizedBox(height: 24),
                          if (listing.deliveryOption != 'self_pickup')
                            _buildDeliverySelector(controller, listing),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _buildClaimBar(controller, listing),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildImageHeader(FoodDetailController controller, FoodListing listing) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F6E56).withValues(alpha: 0.1),
            ),
            child: listing.images.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.image,
                  color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                  size: 64,
                ),
                const SizedBox(height: 10),
                Text(
                  listing.category,
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                    fontSize: 14,
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
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, const Color(0xFF0D3D30)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12, left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D3D30).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
                ),
                child: const Icon(Iconsax.arrow_left, color: Color(0xFF5DCAA5), size: 22),
              ),
            ),
          ),
          Positioned(
            top: 12, right: 16,
            child: Obx(() => GestureDetector(
              onTap: () => controller.isSaved.value = !controller.isSaved.value,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D3D30).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: controller.isSaved.value
                        ? const Color(0xFFEF9F27).withValues(alpha: 0.5)
                        : const Color(0xFF1D9E75).withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  controller.isSaved.value ? Iconsax.heart5 : Iconsax.heart,
                  color: controller.isSaved.value ? const Color(0xFFEF9F27) : const Color(0xFF5DCAA5),
                  size: 22,
                ),
              ),
            )),
          ),
          if (controller.isUrgent)
            Positioned(
              top: 12, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF9F27),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF9F27).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.clock, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'URGENT — ${controller.timeLeftText}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (listing.images.length > 1)
            Positioned(
              bottom: 20, left: 0, right: 0,
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(listing.images.length, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: controller.currentImageIndex.value == i ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: controller.currentImageIndex.value == i
                        ? const Color(0xFFEF9F27)
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              )),
            ),
        ],
      ),
    );
  }

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
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _StatusBadge(
                    label: listing.dietaryType,
                    color: listing.dietaryType == 'Vegetarian' || listing.dietaryType == 'Vegan'
                        ? const Color(0xFF1D9E75)
                        : const Color(0xFFEF9F27),
                  ),
                  const SizedBox(width: 10),
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
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            )),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Iconsax.location, color: Color(0xFFEF9F27), size: 14),
                const SizedBox(width: 4),
                Text(
                  '${listing.distanceKm} km',
                  style: const TextStyle(color: Color(0xFFEF9F27), fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickInfo(FoodListing listing) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          _QuickInfoItem(icon: Iconsax.weight, label: 'Quantity', value: '${listing.quantity} ${listing.unit}'),
          _Divider(),
          _QuickInfoItem(icon: Iconsax.calendar, label: 'Expires', value: '${listing.expiryDate.day}/${listing.expiryDate.month}'),
          _Divider(),
          _QuickInfoItem(icon: Iconsax.clock, label: 'Pickup', value: listing.pickupFrom),
          _Divider(),
          _QuickInfoItem(
            icon: listing.deliveryOption == 'self_pickup' ? Iconsax.man : listing.deliveryOption == 'volunteer' ? Iconsax.truck : Iconsax.people,
            label: 'Delivery',
            value: listing.deliveryOption == 'self_pickup' ? 'Self' : listing.deliveryOption == 'volunteer' ? 'Volunteer' : 'Both',
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(FoodListing listing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'About this Food'),
        const SizedBox(height: 12),
        Text(
          listing.description,
          style: TextStyle(
            color: const Color(0xFF9FE1CB).withValues(alpha: 0.8),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildDonorCard(FoodListing listing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Donor'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
                  ),
                ),
                child: Center(
                  child: Text(
                    listing.donorName[0],
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.donorName,
                      style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      listing.donorType,
                      style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Iconsax.star5, color: Color(0xFFEF9F27), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${listing.donorRating}',
                          style: const TextStyle(color: Color(0xFFEF9F27), fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${listing.donorDonations} donations',
                          style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.5), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Iconsax.verify, color: Color(0xFF1D9E75), size: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickupDetails(FoodListing listing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Pickup Details'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              _PickupRow(icon: Iconsax.location, label: 'Address', value: listing.pickupLocation),
              const SizedBox(height: 16),
              _PickupRow(icon: Iconsax.clock, label: 'Time Window', value: '${listing.pickupFrom} – ${listing.pickupTo}'),
              if (listing.pickupInstructions.isNotEmpty) ...[
                const SizedBox(height: 16),
                _PickupRow(icon: Iconsax.info_circle, label: 'Instructions', value: listing.pickupInstructions),
              ],
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.map_1, color: Color(0xFF5DCAA5), size: 18),
                      SizedBox(width: 10),
                      Text('View on Map', style: TextStyle(color: Color(0xFF5DCAA5), fontSize: 14, fontWeight: FontWeight.w600)),
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

  Widget _buildDeliverySelector(FoodDetailController controller, FoodListing listing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Delivery Method'),
        const SizedBox(height: 12),
        Obx(() => Row(
          children: [
            _DeliveryCard(
              title: 'Self Pickup',
              icon: Iconsax.man,
              isSelected: controller.selectedDelivery.value == 'self_pickup',
              onTap: () => controller.selectedDelivery.value = 'self_pickup',
            ),
            const SizedBox(width: 14),
            _DeliveryCard(
              title: 'Volunteer',
              icon: Iconsax.truck,
              isSelected: controller.selectedDelivery.value == 'volunteer',
              onTap: () => controller.selectedDelivery.value = 'volunteer',
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildClaimBar(FoodDetailController controller, FoodListing listing) {
    final isExpired = listing.status == 'expired' || listing.expiryDate.isBefore(DateTime.now());
    final isClaimed = listing.status == 'claimed';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      decoration: BoxDecoration(
        color: const Color(0xFF0D3D30),
        border: Border(top: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.2))),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 25, offset: const Offset(0, -5))],
      ),
      child: Obx(() {
        if (isExpired) return _StatusLabel(text: 'This listing has expired', color: Colors.redAccent);
        if (isClaimed) return _StatusLabel(text: 'Already claimed by someone', color: const Color(0xFFEF9F27));

        return GestureDetector(
          onTap: controller.isClaiming.value ? null : controller.claimFood,
          child: Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFEF9F27), Color(0xFFBA7517)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFFEF9F27).withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: Center(
              child: controller.isClaiming.value
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.heart, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Claim This Food', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _StatusLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(child: Text(text, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600))),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryCard({required this.title, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1D9E75).withValues(alpha: 0.2) : const Color(0xFF0F6E56).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? const Color(0xFF1D9E75) : const Color(0xFF1D9E75).withValues(alpha: 0.2), width: isSelected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF5DCAA5) : const Color(0xFF5DCAA5).withValues(alpha: 0.4), size: 28),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(color: isSelected ? const Color(0xFF9FE1CB) : const Color(0xFF9FE1CB).withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 18, fontWeight: FontWeight.w700));
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
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
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF5DCAA5), size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), fontSize: 10)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: const Color(0xFF1D9E75).withValues(alpha: 0.2));
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
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF5DCAA5), size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
