import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/user_controller.dart';
import '../FoodDetail/food_detail.dart';
import '../NotificationScreen/notification_screen.dart';
import '../ProfileScreen/profile_screen.dart';
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
        border: Border(top: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.2), width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFEF9F27),
        unselectedItemColor: const Color(0xFF5DCAA5).withValues(alpha: 0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
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
          
          /// LIVE DATA FROM FIREBASE
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('FoodListings').where('Status', isEqualTo: 'Available').orderBy('CreatedAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(20), child: SelectableText('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red))));
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
              
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No active food listings available right now.', style: TextStyle(color: Color(0xFF5DCAA5)))));

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return _FoodCard(
                    title: data['FoodName'] ?? '',
                    donor: data['DonorName'] ?? 'Donor',
                    distance: '0.5 km',
                    quantity: data['Quantity'] ?? '',
                    category: data['Category'] ?? 'Food',
                    expiresIn: 'Active',
                    isUrgent: false,
                    data: data,
                    docId: docs[index].id,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 32),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

class _FoodCard extends StatefulWidget {
  const _FoodCard({
    required this.title, required this.donor, required this.distance,
    required this.quantity, required this.category, required this.expiresIn,
    required this.isUrgent, required this.data, this.docId,
    this.isClaimHistory = false, this.claimStatus,
  });

  final String title, donor, distance, quantity, category, expiresIn;
  final bool isUrgent;
  final Map<String, dynamic> data;
  final String? docId;
  final bool isClaimHistory;
  final String? claimStatus;

  @override
  State<_FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<_FoodCard> {
  bool _isLoading = false;

  void _requestListing() async {
    final userController = UserController.instance;
    if (widget.docId == null || _isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      await FirebaseFirestore.instance.collection('Requests').add({
        'ListingId': widget.docId,
        'FoodName': widget.title,
        'DonorId': widget.data['DonorId'],
        'RecipientId': FirebaseAuth.instance.currentUser?.uid,
        'RecipientName': userController.userName.value,
        'Status': 'Pending',
        'CreatedAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Request Sent', 'Your request has been sent to the donor.', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send request: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.data.isNotEmpty) Get.to(() => const FoodDetailScreen(), arguments: widget.data);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.isUrgent ? const Color(0xFFEF9F27).withValues(alpha: 0.4) : const Color(0xFF1D9E75).withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(widget.title, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 16, fontWeight: FontWeight.bold))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF1D9E75).withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.3))),
                child: Text(widget.category, style: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Iconsax.user, color: Color(0xFF5DCAA5), size: 14),
                const SizedBox(width: 4),
                Text(widget.donor, style: TextStyle(color: const Color(0xFF5DCAA5).withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.data['Description'] != null && widget.data['Description'].toString().isNotEmpty) ...[
              Text(widget.data['Description'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: const Color(0xFF9FE1CB).withOpacity(0.7), fontSize: 12)),
              const SizedBox(height: 12),
            ],
            Row(children: [
              _Tag(icon: Iconsax.location, label: widget.data['PickupLocation'] ?? 'Unknown Location'),
              const SizedBox(width: 12),
              _Tag(icon: Iconsax.box, label: widget.quantity),
              const SizedBox(width: 12),
              _Tag(icon: Iconsax.clock, label: widget.expiresIn, color: widget.isUrgent ? const Color(0xFFEF9F27) : null),
            ]),
            const SizedBox(height: 16),
            if (widget.isClaimHistory && widget.claimStatus != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: widget.claimStatus == 'Accepted' ? Colors.green.withOpacity(0.15) : widget.claimStatus == 'Rejected' ? Colors.red.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.claimStatus == 'Accepted' ? Colors.green : widget.claimStatus == 'Rejected' ? Colors.red : Colors.orange),
                ),
                child: Center(child: Text('Status: ${widget.claimStatus}', style: TextStyle(color: widget.claimStatus == 'Accepted' ? Colors.green : widget.claimStatus == 'Rejected' ? Colors.red : Colors.orange, fontSize: 14, fontWeight: FontWeight.bold))),
              )
            else
              Row(children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Requests').where('ListingId', isEqualTo: widget.docId).where('RecipientId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
                    builder: (context, snapshot) {
                      final hasRequested = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                      return GestureDetector(
                        onTap: hasRequested 
                          ? () => Get.snackbar('Info', 'You have already claimed this food listing.', backgroundColor: const Color(0xFF0F6E56), colorText: Colors.white)
                          : _requestListing,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: hasRequested
                              ? LinearGradient(colors: [const Color(0xFF5DCAA5).withOpacity(0.2), const Color(0xFF1D9E75).withOpacity(0.2)])
                              : const LinearGradient(colors: [Color(0xFFEF9F27), Color(0xFFBA7517)]),
                            borderRadius: BorderRadius.circular(12),
                            border: hasRequested ? Border.all(color: const Color(0xFF1D9E75).withOpacity(0.3)) : null,
                            boxShadow: hasRequested ? [] : [BoxShadow(color: const Color(0xFFEF9F27).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
                          ),
                          child: Center(
                            child: _isLoading && !hasRequested
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(
                                  hasRequested ? 'Already Claimed' : 'Claim Food', 
                                  style: TextStyle(color: hasRequested ? const Color(0xFF5DCAA5) : Colors.white, fontSize: 14, fontWeight: FontWeight.bold)
                                ),
                          ),
                        ),
                      );
                    }
                  ),
                ),
                const SizedBox(width: 12),
                if (widget.data['PickupLocation'] != null && widget.data['PickupLocation'].toString().isNotEmpty)
                  _IconActionBtn(icon: Iconsax.map, onTap: () => _launchMaps(widget.data['PickupLocation'])),
              ]),
          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  
  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: FSizzes.defaultSpace),
        child: Column(children: [
          const SizedBox(height: 20),
          Center(
            child: Column(children: [
              Stack(children: [
                Obx(() => CircleAvatar(radius: 44, backgroundColor: const Color(0xFF0F6E56), child: Text(userController.userName.value.isNotEmpty ? userController.userName.value[0].toUpperCase() : 'U', style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 36, fontWeight: FontWeight.w700)))),
                _EditIcon(),
              ]),
              const SizedBox(height: 12),
              Obx(() => Text(userController.userName.value, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 20, fontWeight: FontWeight.w700))),
              const SizedBox(height: 4),
              Obx(() => _RoleBadge(label: userController.userRole.value.capitalizeFirst ?? 'Recipient')),
            ]),
          ),
          const SizedBox(height: 24),
          
          if (uid != null)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Requests').where('RecipientId', isEqualTo: uid).snapshots(),
              builder: (context, snapshot) {
                int totalRequests = 0;
                int accepted = 0;
                int pending = 0;

                if (snapshot.hasData) {
                  totalRequests = snapshot.data!.docs.length;
                  accepted = snapshot.data!.docs.where((d) => (d.data() as Map<String, dynamic>)['Status'] == 'Accepted').length;
                  pending = snapshot.data!.docs.where((d) => (d.data() as Map<String, dynamic>)['Status'] == 'Pending').length;
                }

                return Row(children: [
                  _StatCard(label: 'Total\nClaimed', value: '$accepted', icon: Iconsax.heart),
                  const SizedBox(width: 12),
                  _StatCard(label: 'Pending\nRequests', value: '$pending', icon: Iconsax.clock),
                  const SizedBox(width: 12),
                  _StatCard(label: 'Total\nRequests', value: '$totalRequests', icon: Iconsax.box),
                ]);
              },
            ),

          const SizedBox(height: 24),
          _MenuSection(title: 'Account Settings', items: [
            _MenuItem(icon: Iconsax.user, label: 'Edit Profile Details', onTap: () => Get.to(() => EditProfileScreen(role: userController.userRole.value))),
          ]),
          const SizedBox(height: 16),
          _LogoutBtn(),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

// ── REUSABLE UI COMPONENTS ───────────────────────────────────────────────────

class _Tag extends StatelessWidget {
  final IconData icon; final String label; final Color? color;
  const _Tag({required this.icon, required this.label, this.color});
  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF5DCAA5);
    return Row(children: [
      Icon(icon, color: c.withValues(alpha: 0.7), size: 12),
      const SizedBox(width: 3),
      Text(label, style: TextStyle(color: c.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w500)),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final String label, value; final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF0F6E56).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2))),
        child: Column(children: [
          Icon(icon, color: const Color(0xFFEF9F27), size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 18, fontWeight: FontWeight.w700)),
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.7), fontSize: 10)),
        ]),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title; final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(title, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w600))),
      Container(decoration: BoxDecoration(color: const Color(0xFF0F6E56).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2))), child: Column(children: items)),
    ]);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.1), width: 0.5))),
        child: Row(children: [
          Icon(icon, color: const Color(0xFF5DCAA5), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 14))),
          Icon(Iconsax.arrow_right_3, color: const Color(0xFF5DCAA5).withValues(alpha: 0.4), size: 16),
        ]),
      ),
    );
  }
}

class _IconActionBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _IconActionBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF0F6E56).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3))),
        child: Icon(icon, color: const Color(0xFF5DCAA5), size: 18),
      ),
    );
  }
}

class _LogoutBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Get.offAll(() => const LoginScreen()),
        icon: const Icon(Iconsax.logout, color: Color(0xFFC62828), size: 18),
        label: const Text(FTexts.logout, style: TextStyle(color: Color(0xFFC62828))),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFC62828), width: 0.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
      ),
    );
  }
}

class _EditIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFEF9F27), Color(0xFFBA7517)]), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF0D3D30), width: 2)), child: const Icon(Iconsax.edit, color: Colors.white, size: 14)));
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;
  const _RoleBadge({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF1D9E75).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.4))), child: Text(label, style: const TextStyle(color: Color(0xFF5DCAA5), fontSize: 12, fontWeight: FontWeight.w500)));
  }
}

class _UrgentBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFEF9F27).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEF9F27).withValues(alpha: 0.4))), child: const Text('Urgent', style: TextStyle(color: Color(0xFFEF9F27), fontSize: 10, fontWeight: FontWeight.w600)));
  }
}


class _MyClaimsTab extends StatelessWidget {
  const _MyClaimsTab();
  
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('Please log in', style: TextStyle(color: Color(0xFF5DCAA5))));
    
    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 16), child: Text('My Claims', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF9FE1CB)))),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Requests').where('RecipientId', isEqualTo: uid).orderBy('CreatedAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: SelectableText('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) return const Center(child: Text('You have not made any food requests yet.', style: TextStyle(color: Color(0xFF5DCAA5))));
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final reqData = docs[index].data() as Map<String, dynamic>;
                  final status = reqData['Status'] ?? 'Unknown';
                  final listingId = reqData['ListingId'];

                  if (listingId == null) return const SizedBox();

                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('FoodListings').doc(listingId).snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData || !snap.data!.exists) return const SizedBox();
                      final data = snap.data!.data() as Map<String, dynamic>;
                      
                      return _FoodCard(
                        title: data['FoodName'] ?? '',
                        donor: data['DonorName'] ?? 'Donor',
                        distance: '0.5 km',
                        quantity: data['Quantity'] ?? '',
                        category: data['Category'] ?? 'Food',
                        expiresIn: 'Active',
                        isUrgent: false,
                        data: data,
                        docId: snap.data!.id,
                        isClaimHistory: true,
                        claimStatus: status,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
