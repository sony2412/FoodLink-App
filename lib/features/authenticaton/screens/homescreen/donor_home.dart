import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/user_controller.dart';
import '../FindNGO/find_ngo.dart';
import '../NotificationScreen/notification_screen.dart';
import '../PostFood/post_food.dart';
import '../login/login.dart';

class DonorDashboard extends StatefulWidget {
  const DonorDashboard({super.key});

  @override
  State<DonorDashboard> createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _DonorHomePage(),
    _DonorListingsPage(),
    _DonorHistoryPage(),
    _DonorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FScreenBackground(child: _pages[_currentIndex]),
      bottomNavigationBar: _DonorBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _DonorBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _DonorBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D3D30),
        border: Border(top: BorderSide(color: const Color(0xFF1D9E75).withOpacity(0.2), width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Iconsax.home_2, label: 'Home', index: 0, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Iconsax.box, label: 'Listings', index: 1, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Iconsax.clock, label: 'History', index: 2, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Iconsax.user, label: 'Profile', index: 3, currentIndex: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon; final String label; final int index; final int currentIndex; final ValueChanged<int> onTap;
  const _NavItem({required this.icon, required this.label, required this.index, required this.currentIndex, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFFEF9F27) : const Color(0xFF5DCAA5).withOpacity(0.5), size: 22),
          Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFFEF9F27) : const Color(0xFF5DCAA5).withOpacity(0.5))),
        ],
      ),
    );
  }
}

class _DonorHomePage extends StatelessWidget {
  const _DonorHomePage();

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(userController)),
          SliverToBoxAdapter(child: _buildQuickActions()),
          const SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('Recent Submissions', style: TextStyle(color: Color(0xFF9FE1CB), fontSize: 16, fontWeight: FontWeight.bold)),
          )),
          _buildLiveListingsList(FirebaseAuth.instance.currentUser?.uid),
        ],
      ),
    );
  }

  Widget _buildHeader(UserController userController) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Good morning 👋', style: TextStyle(color: Color(0xFF5DCAA5), fontSize: 13)),
            Obx(() => Text(userController.userName.value, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 22, fontWeight: FontWeight.bold))),
          ]),
          IconButton(onPressed: () => Get.to(() => const NotificationsScreen()), icon: const Icon(Iconsax.notification, color: Color(0xFF5DCAA5))),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Expanded(child: _ActionBtn(label: 'Post Food', icon: Iconsax.add_circle, color: const Color(0xFFEF9F27), onTap: () => Get.to(() => const PostFoodScreen()))),
        const SizedBox(width: 15),
        Expanded(child: _ActionBtn(label: 'Find NGO', icon: Iconsax.location, color: const Color(0xFF1D9E75), onTap: () => Get.to(() => const FindNGOsScreen()))),
      ]),
    );
  }

  Widget _buildLiveListingsList(String? uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('FoodListings').where('DonorId', isEqualTo: uid).orderBy('CreatedAt', descending: true).limit(3).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const SliverToBoxAdapter(child: Center(child: Text('No listings yet', style: TextStyle(color: Color(0xFF5DCAA5)))));
        
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return _ListingTile(data: data);
          }, childCount: docs.length),
        );
      },
    );
  }
}

class _DonorListingsPage extends StatelessWidget {
  const _DonorListingsPage();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        const Padding(padding: EdgeInsets.all(20), child: Text('All My Listings', style: TextStyle(color: Color(0xFF9FE1CB), fontSize: 22, fontWeight: FontWeight.bold))),
        Expanded(child: _DonorAllListingsList(uid: FirebaseAuth.instance.currentUser?.uid)),
      ]),
    );
  }
}

class _DonorAllListingsList extends StatelessWidget {
  final String? uid;
  const _DonorAllListingsList({required this.uid});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('FoodListings').where('DonorId', isEqualTo: uid).orderBy('CreatedAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('You haven\'t posted any food yet.', style: TextStyle(color: Color(0xFF5DCAA5))));
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _ListingTile(data: data, docId: doc.id);
          },
        );
      },
    );
  }
}

class _ListingTile extends StatelessWidget {
  final Map<String, dynamic> data; final String? docId;
  const _ListingTile({required this.data, this.docId});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF0F6E56).withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.2))),
      child: Row(children: [
        const Icon(Iconsax.box, color: Color(0xFFEF9F27), size: 30),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data['FoodName'] ?? '', style: const TextStyle(color: Color(0xFF9FE1CB), fontWeight: FontWeight.bold)),
          Text(data['Quantity'] ?? '', style: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 12)),
        ])),
        if (docId != null) IconButton(onPressed: () => _deleteListing(docId!), icon: const Icon(Iconsax.trash, color: Colors.red, size: 20)),
      ]),
    );
  }

  void _deleteListing(String id) {
    Get.defaultDialog(
      title: 'Delete Listing', middleText: 'Are you sure?',
      backgroundColor: const Color(0xFF0D3D30), titleStyle: const TextStyle(color: Color(0xFF9FE1CB)), middleTextStyle: const TextStyle(color: Color(0xFF5DCAA5)),
      onConfirm: () async {
        await FirebaseFirestore.instance.collection('FoodListings').doc(id).delete();
        Get.back();
      },
      textConfirm: 'Delete', confirmTextColor: Colors.white, textCancel: 'Cancel', cancelTextColor: const Color(0xFF5DCAA5),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label; final IconData icon; final Color color; final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: color.withOpacity(0.3))),
        child: Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
      ),
    );
  }
}

class _DonorHistoryPage extends StatelessWidget { const _DonorHistoryPage(); @override Widget build(BuildContext context) => const Center(child: Text('History Coming Soon', style: TextStyle(color: Color(0xFF5DCAA5)))); }
class _DonorProfilePage extends StatelessWidget { const _DonorProfilePage(); @override Widget build(BuildContext context) => const Center(child: Text('Profile Coming Soon', style: TextStyle(color: Color(0xFF5DCAA5)))); }
