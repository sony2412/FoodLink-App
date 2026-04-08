import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';


class FindNGOsScreen extends StatefulWidget {
  const FindNGOsScreen({super.key});

  @override
  State<FindNGOsScreen> createState() => _FindNGOsScreenState();
}

class _FindNGOsScreenState extends State<FindNGOsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All', 'Shelter', 'Children', 'Elderly', 'Food Bank', 'Hospital', 'Education',
  ];

  final List<_NGOData> _ngos = [
    _NGOData(
      name: 'Aasha NGO',
      type: 'Shelter',
      distance: '1.2 km',
      address: 'Sector 21, Civil Lines',
      needs: 'Cooked meals, Rice & Dal',
      phone: '+91 98765 43210',
      timing: '8 AM – 8 PM',
      capacity: '150 people/day',
      rating: 4.8,
      totalReceived: 342,
      isVerified: true,
      isOpen: true,
    ),
    _NGOData(
      name: 'Bal Vikas Trust',
      type: 'Children',
      distance: '2.8 km',
      address: 'Dharampeth, Nagpur',
      needs: 'Any food, Fruits, Milk',
      phone: '+91 91234 56789',
      timing: '9 AM – 6 PM',
      capacity: '80 children/day',
      rating: 4.9,
      totalReceived: 218,
      isVerified: true,
      isOpen: true,
    ),
    _NGOData(
      name: 'City Food Bank',
      type: 'Food Bank',
      distance: '3.5 km',
      address: 'Sitabuldi, Nagpur',
      needs: 'Raw ingredients, Packaged food',
      phone: '+91 88765 43210',
      timing: '7 AM – 10 PM',
      capacity: '500 kg/day',
      rating: 4.7,
      totalReceived: 891,
      isVerified: true,
      isOpen: true,
    ),
    _NGOData(
      name: 'Sunrise Old Age Home',
      type: 'Elderly',
      distance: '4.1 km',
      address: 'Ramdaspeth, Nagpur',
      needs: 'Soft food, Fruits, Vegetables',
      phone: '+91 77654 32109',
      timing: '8 AM – 7 PM',
      capacity: '60 seniors/day',
      rating: 4.6,
      totalReceived: 156,
      isVerified: false,
      isOpen: true,
    ),
    _NGOData(
      name: 'Hope Children Hospital',
      type: 'Hospital',
      distance: '5.2 km',
      address: 'Wardha Road, Nagpur',
      needs: 'Hygienic packed food only',
      phone: '+91 90123 45678',
      timing: '24 hours',
      capacity: '200 patients/day',
      rating: 4.5,
      totalReceived: 412,
      isVerified: true,
      isOpen: true,
    ),
    _NGOData(
      name: 'Gyaan Jyoti School',
      type: 'Education',
      distance: '6.0 km',
      address: 'Kamptee Road, Nagpur',
      needs: 'Tiffin meals, Snacks',
      phone: '+91 82345 67890',
      timing: '7 AM – 2 PM (School days)',
      capacity: '300 students/day',
      rating: 4.7,
      totalReceived: 287,
      isVerified: true,
      isOpen: false,
    ),
  ];

  List<_NGOData> get _filtered {
    return _ngos.where((n) {
      final matchCategory = _selectedCategory == 'All' || n.type == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          n.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          n.type.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          n.needs.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find NGOs & Recipients',
                              style: TextStyle(
                                color: Color(0xFF9FE1CB),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Nearby organizations that need food',
                              style: TextStyle(
                                color: Color(0xFF5DCAA5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Map button
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(Iconsax.location,
                            color: Color(0xFF5DCAA5), size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: FSizzes.defaultSpace),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.search_normal,
                            color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                            size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(
                                color: Color(0xFFE8FBF4), fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search NGOs, needs...',
                              hintStyle: TextStyle(
                                color: const Color(0xFF5DCAA5)
                                    .withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (v) => setState(() => _searchQuery = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category chips
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: FSizzes.defaultSpace),
                    itemCount: _categories.length,
                    itemBuilder: (_, i) {
                      final cat = _categories[i];
                      final isSelected = cat == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(colors: [
                              Color(0xFFEF9F27),
                              Color(0xFFBA7517)
                            ])
                                : null,
                            color: isSelected
                                ? null
                                : const Color(0xFF0F6E56)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : const Color(0xFF1D9E75)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF5DCAA5),
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Results count
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: FSizzes.defaultSpace),
                  child: Row(
                    children: [
                      Text(
                        '${_filtered.length} organizations found',
                        style: TextStyle(
                          color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // NGO List
                Expanded(
                  child: _filtered.isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: FSizzes.defaultSpace),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) =>
                        _NGOCard(ngo: _filtered[i]),
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

// ── NGO CARD ──────────────────────────────────────────────────────────────────

class _NGOCard extends StatelessWidget {
  const _NGOCard({required this.ngo});
  final _NGOData ngo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Iconsax.building,
                      color: Color(0xFF5DCAA5), size: 26),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ngo.name,
                              style: const TextStyle(
                                color: Color(0xFF9FE1CB),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (ngo.isVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D9E75)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF1D9E75)
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Iconsax.verify,
                                      color: Color(0xFF5DCAA5), size: 10),
                                  SizedBox(width: 3),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      color: Color(0xFF5DCAA5),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF9F27)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ngo.type,
                              style: const TextStyle(
                                color: Color(0xFFFAC775),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Iconsax.location,
                              color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                              size: 12),
                          const SizedBox(width: 3),
                          Text(
                            ngo.distance,
                            style: TextStyle(
                              color: const Color(0xFF5DCAA5).withValues(alpha: 0.8),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 6, height: 6,
                            decoration: BoxDecoration(
                              color: ngo.isOpen
                                  ? const Color(0xFF1D9E75)
                                  : const Color(0xFFC62828),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ngo.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: ngo.isOpen
                                  ? const Color(0xFF5DCAA5)
                                  : const Color(0xFFC62828),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Column(
              children: [
                _DetailRow(icon: Iconsax.location, text: ngo.address),
                const SizedBox(height: 6),
                _DetailRow(icon: Iconsax.clock, text: ngo.timing),
                const SizedBox(height: 6),
                _DetailRow(icon: Iconsax.people, text: 'Capacity: ${ngo.capacity}'),
                const SizedBox(height: 8),
                // Needs chip
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF9F27).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFEF9F27).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.heart,
                          color: Color(0xFFEF9F27), size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Needs: ${ngo.needs}',
                          style: const TextStyle(
                            color: Color(0xFFFAC775),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(Iconsax.star5,
                    color: const Color(0xFFEF9F27), size: 14),
                const SizedBox(width: 4),
                Text(
                  ngo.rating.toString(),
                  style: const TextStyle(
                    color: Color(0xFFEF9F27),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Iconsax.box,
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                    size: 13),
                const SizedBox(width: 4),
                Text(
                  '${ngo.totalReceived} donations received',
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.snackbar(
                        'Donation Request Sent',
                        'Your request to donate to ${ngo.name} has been sent!',
                        backgroundColor: const Color(0xFF1D9E75),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        icon: const Icon(Iconsax.tick_circle,
                            color: Colors.white),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Donate Here',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Call button
                GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      'Contact',
                      'Calling ${ngo.phone}',
                      backgroundColor: const Color(0xFF0F6E56),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(Iconsax.call,
                        color: Color(0xFF5DCAA5), size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                // Direction button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(Iconsax.location,
                        color: Color(0xFF5DCAA5), size: 18),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), size: 13),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF5DCAA5).withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.building,
                color: const Color(0xFF1D9E75).withValues(alpha: 0.5), size: 36),
          ),
          const SizedBox(height: 16),
          const Text(
            'No organizations found',
            style: TextStyle(
              color: Color(0xFF9FE1CB),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different category or search term',
            style: TextStyle(
              color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── DATA MODEL ────────────────────────────────────────────────────────────────

class _NGOData {
  final String name, type, distance, address, needs, phone, timing, capacity;
  final double rating;
  final int totalReceived;
  final bool isVerified, isOpen;

  const _NGOData({
    required this.name,
    required this.type,
    required this.distance,
    required this.address,
    required this.needs,
    required this.phone,
    required this.timing,
    required this.capacity,
    required this.rating,
    required this.totalReceived,
    required this.isVerified,
    required this.isOpen,
  });
}