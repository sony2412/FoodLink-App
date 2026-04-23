import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_controller.dart';
import '../NotificationScreen/notification_screen.dart';
import '../PostFood/post_food.dart';
import '../ProfileScreen/profile_screen.dart';
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
        border: Border(top: BorderSide(color: const Color(0xFF1D9E75).withOpacity(0.25), width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Iconsax.home_2, label: 'Home', index: 0, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Iconsax.clock, label: 'History', index: 1, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Iconsax.user, label: 'Profile', index: 2, currentIndex: currentIndex, onTap: onTap),
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
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFFEF9F27) : const Color(0xFF5DCAA5).withOpacity(0.4), size: 22),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: isActive ? const Color(0xFFEF9F27) : const Color(0xFF5DCAA5).withOpacity(0.4))),
        ],
      ),
    );
  }
}

// ── HOME PAGE ────────────────────────────────────────────────────────────────

class _DonorHomePage extends StatelessWidget {
  const _DonorHomePage();

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(userController)),
          SliverToBoxAdapter(child: _buildImpactStats(FirebaseAuth.instance.currentUser?.uid)),
          SliverToBoxAdapter(child: _buildQuickActions()),
          const SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text('Active Listings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB))),
          )),
          _buildDynamicListings(FirebaseAuth.instance.currentUser?.uid),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildHeader(UserController userController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Good morning 👋', style: TextStyle(fontSize: 13, color: Color(0xFF5DCAA5))),
            Obx(() => Text(userController.userName.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF9FE1CB)))),
          ]),
          _IconBtn(icon: Iconsax.notification, onTap: () => Get.to(() => const NotificationsScreen())),
        ],
      ),
    );
  }

  Widget _buildImpactStats(String? uid) {
    if (uid == null) return const SizedBox();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('FoodListings').where('DonorId', isEqualTo: uid).snapshots(),
      builder: (context, snapshot) {
        int total = 0;
        int confirmed = 0;
        int available = 0;

        if (snapshot.hasData) {
          total = snapshot.data!.docs.length;
          confirmed = snapshot.data!.docs.where((d) => (d.data() as Map<String, dynamic>)['Status'] == 'Confirmed').length;
          available = snapshot.data!.docs.where((d) => (d.data() as Map<String, dynamic>)['Status'] == 'Available').length;
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F6E56), Color(0xFF1D9E75)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ImpactStat(icon: Iconsax.box, value: '$total', label: 'Total\nListings'),
                _ImpactStat(icon: Iconsax.tick_circle, value: '$confirmed', label: 'Confirmed\nDonations'),
                _ImpactStat(icon: Iconsax.clock, value: '$available', label: 'Active\nListings'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(children: [
        Expanded(child: _QuickActionCard(icon: Iconsax.add_circle, label: 'Post Food', subtitle: 'List surplus', color: const Color(0xFFEF9F27), onTap: () => Get.to(() => const PostFoodScreen()))),
        const SizedBox(width: 12),
        ]),
    );
  }

  Widget _buildDynamicListings(String? uid) {
    if (uid == null) return const SliverToBoxAdapter(child: SizedBox());
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('FoodListings').where('DonorId', isEqualTo: uid).where('Status', isEqualTo: 'Available').orderBy('CreatedAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return SliverToBoxAdapter(child: Center(child: Padding(padding: const EdgeInsets.all(20), child: SelectableText('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)))));
        if (snapshot.connectionState == ConnectionState.waiting) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20), child: Text('You have no active listings at the moment.', style: TextStyle(color: Color(0xFF5DCAA5))))));
        
        return SliverList(delegate: SliverChildBuilderDelegate((context, index) {
          final data = docs[index].data() as Map<String, dynamic>;
          return _FoodListingCard(data: data, docId: docs[index].id);
        }, childCount: docs.length));
      },
    );
  }
}



// ── COMPONENTS ───────────────────────────────────────────────────────────────

class _FoodListingCard extends StatelessWidget {
  final Map<String, dynamic> data; final String? docId;
  final bool isHistory;
  const _FoodListingCard({required this.data, this.docId, this.isHistory = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF1D9E75).withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.3))),
                child: Text(data['Category'] ?? 'Food', style: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  if (data['PickupLocation'] != null && data['PickupLocation'].toString().isNotEmpty)
                    IconButton(onPressed: () => _launchMaps(data['PickupLocation']), icon: const Icon(Iconsax.map, color: Color(0xFFEF9F27), size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints(), splashRadius: 20),
                  
                  if (!isHistory) ...[
                    const SizedBox(width: 16),
                    if (docId != null) IconButton(onPressed: () => _edit(context), icon: const Icon(Iconsax.edit, color: Color(0xFF5DCAA5), size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints(), splashRadius: 20),
                    const SizedBox(width: 16),
                    if (docId != null) IconButton(onPressed: () => _delete(docId!), icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints(), splashRadius: 20),
                  ]
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(data['FoodName'] ?? '', style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          if (data['Description'] != null && data['Description'].toString().isNotEmpty) ...[
            Text(data['Description'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: const Color(0xFF9FE1CB).withOpacity(0.7), fontSize: 13)),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF0D3D30).withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Iconsax.box, color: Color(0xFF5DCAA5), size: 16),
                const SizedBox(width: 6),
                Text(data['Quantity'] ?? '', style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                const Icon(Iconsax.location, color: Color(0xFF5DCAA5), size: 16),
                const SizedBox(width: 6),
                Expanded(child: Text(data['PickupLocation'] ?? 'Unknown', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 12, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          if (isHistory && data['ClaimedByName'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1D9E75).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.tick_circle, color: Color(0xFF5DCAA5), size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Claimed by: ${data['ClaimedByName']}', style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }

  Future<void> _launchMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not open maps', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _delete(String id) => FirebaseFirestore.instance.collection('FoodListings').doc(id).delete();

  void _edit(BuildContext context) {
    final nameCtrl = TextEditingController(text: data['FoodName']);
    final qtyCtrl = TextEditingController(text: data['Quantity']);
    Get.defaultDialog(
      title: 'Edit Listing',
      titleStyle: const TextStyle(color: Color(0xFF9FE1CB)),
      backgroundColor: const Color(0xFF0D3D30),
      content: Column(
        children: [
          TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Food Name', labelStyle: TextStyle(color: Color(0xFF5DCAA5)))),
          TextField(controller: qtyCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Quantity', labelStyle: TextStyle(color: Color(0xFF5DCAA5)))),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (docId != null) {
            FirebaseFirestore.instance.collection('FoodListings').doc(docId!).update({
              'FoodName': nameCtrl.text,
              'Quantity': qtyCtrl.text,
            });
            Get.back();
            Get.snackbar('Updated', 'Listing updated successfully', backgroundColor: Colors.green, colorText: Colors.white);
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF9F27)),
        child: const Text('Save', style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final IconData icon; final String value; final String label;
  const _ImpactStat({required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10), textAlign: TextAlign.center),
    ]);
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon; final String label; final String subtitle; final Color color; final VoidCallback onTap;
  const _QuickActionCard({required this.icon, required this.label, required this.subtitle, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF0F2E20).withOpacity(0.4), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w600)), Text(subtitle, style: TextStyle(color: const Color(0xFF5DCAA5).withOpacity(0.6), fontSize: 10))]))])));
  }
}

class _DonorHistoryPage extends StatelessWidget {
  const _DonorHistoryPage();
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(20), child: Text('Donation History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB)))),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('FoodListings').where('DonorId', isEqualTo: uid).where('Status', isEqualTo: 'Confirmed').orderBy('CreatedAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: SelectableText('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) return const Center(child: Text('No confirmed donations yet.', style: TextStyle(color: Color(0xFF5DCAA5))));
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return _FoodListingCard(data: data, docId: docs[index].id, isHistory: true);
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _DonorProfilePage extends StatelessWidget {
  const _DonorProfilePage();
  @override
  Widget build(BuildContext context) {
    final user = UserController.instance;
    return SafeArea(
      child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        Obx(() => CircleAvatar(radius: 36, backgroundColor: const Color(0xFF1D9E75), child: Text(user.userName.value[0], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)))),
        const SizedBox(height: 12),
        Obx(() => Text(user.userName.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB)))),
        const Text('Food Donor', style: TextStyle(color: Color(0xFF5DCAA5), fontSize: 13)),
        const SizedBox(height: 24),
        _ProfileOpt(icon: Iconsax.user_edit, label: 'Edit Profile', onTap: () => Get.to(() => EditProfileScreen(role: 'donor'))),
        _ProfileOpt(icon: Iconsax.logout, label: 'Log Out', onTap: () => Get.offAll(() => const LoginScreen()), isLast: true),
      ])),
    );
  }
}

class _ProfileOpt extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final bool isLast;
  const _ProfileOpt({required this.icon, required this.label, required this.onTap, this.isLast = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF0F2E20).withOpacity(0.4), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.15))),
      child: Row(children: [Icon(icon, color: isLast ? Colors.redAccent : const Color(0xFF5DCAA5), size: 20), const SizedBox(width: 14), Expanded(child: Text(label, style: TextStyle(color: isLast ? Colors.redAccent : Color(0xFF9FE1CB), fontSize: 13))), const Icon(Iconsax.arrow_right_3, color: Colors.white24, size: 16)])));
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF0F6E56).withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.3))), child: Icon(icon, color: const Color(0xFF5DCAA5), size: 20)));
  }
}
