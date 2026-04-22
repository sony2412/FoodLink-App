import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/user_controller.dart';
import '../FoodDetail/food_detail.dart';
import '../NotificationScreen/notification_screen.dart';
import '../ProfileScreen/profile_screen.dart';
import '../TrackDelivery/track_delivery.dart';
import '../login/login.dart';

class RecipientDashboard extends StatefulWidget {
  const RecipientDashboard({super.key});

  @override
  State<RecipientDashboard> createState() => _RecipientDashboardState();
}

class _RecipientDashboardState extends State<RecipientDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    _HomeTab(),
    _BrowseTab(),
    _MyClaimsTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FScreenBackground(child: _tabs[_currentIndex]),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF091F17),
        border: Border(top: BorderSide(color: const Color(0xFF1D9E75).withOpacity(0.2), width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFEF9F27),
        unselectedItemColor: const Color(0xFF5DCAA5).withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.search_normal), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Iconsax.heart), label: 'My Claims'),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: FSizzes.defaultSpace),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(FTexts.homeAppbarTitle, style: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 13)),
              Obx(() => Text('Hello, ${userController.userName.value} 👋', style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 22, fontWeight: FontWeight.bold))),
            ]),
            IconButton(onPressed: () => Get.to(() => const NotificationsScreen()), icon: const Icon(Iconsax.notification, color: Color(0xFF5DCAA5))),
          ]),
          const SizedBox(height: 24),
          const Text('Available Food Nearby', style: TextStyle(color: Color(0xFF9FE1CB), fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildLiveFeed(),
        ]),
      ),
    );
  }

  Widget _buildLiveFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('FoodListings').orderBy('CreatedAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text('No food listings available yet.', style: TextStyle(color: Color(0xFF5DCAA5))));
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return _RecipientFoodCard(data: data);
          },
        );
      },
    );
  }
}

class _RecipientFoodCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RecipientFoodCard({required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF0F6E56).withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(data['FoodName'] ?? '', style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 15, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFFEF9F27).withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEF9F27).withOpacity(0.4))),
            child: Text(data['Category'] ?? '', style: const TextStyle(color: Color(0xFFEF9F27), fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ]),
        const SizedBox(height: 6),
        Text('By: ${data['DonorName'] ?? 'Donor'}', style: TextStyle(color: const Color(0xFF5DCAA5).withOpacity(0.7), fontSize: 12)),
        const SizedBox(height: 10),
        Row(children: [
          _Tag(icon: Iconsax.box, label: data['Quantity'] ?? ''),
          const SizedBox(width: 10),
          _Tag(icon: Iconsax.location, label: data['PickupLocation'] ?? ''),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.to(() => const FoodDetailScreen()),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF9F27), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Claim Now', style: TextStyle(color: Colors.white)),
          ),
        ),
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon; final String label;
  const _Tag({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: const Color(0xFF5DCAA5), size: 12),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 11)),
    ]);
  }
}

class _BrowseTab extends StatelessWidget { const _BrowseTab(); @override Widget build(BuildContext context) => const Center(child: Text('Map View Coming Soon', style: TextStyle(color: Color(0xFF5DCAA5)))); }
class _MyClaimsTab extends StatelessWidget { const _MyClaimsTab(); @override Widget build(BuildContext context) => const Center(child: Text('My Claims Coming Soon', style: TextStyle(color: Color(0xFF5DCAA5)))); }
class _ProfileTab extends StatelessWidget { const _ProfileTab(); @override Widget build(BuildContext context) => const Center(child: Text('Profile Coming Soon', style: TextStyle(color: Color(0xFF5DCAA5)))); }
