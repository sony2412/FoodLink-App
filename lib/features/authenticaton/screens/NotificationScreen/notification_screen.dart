import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/user_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userRole = UserController.instance.userRole.value;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: Stack(
        children: [
          Positioned(
            top: -80, left: -80,
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF0F6E56).withOpacity(0.35),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(FSizzes.defaultSpace, 16, FSizzes.defaultSpace, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F6E56).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.3)),
                          ),
                          child: const Icon(Iconsax.arrow_left, color: Color(0xFF5DCAA5), size: 20),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          FTexts.notifications,
                          style: TextStyle(color: Color(0xFF9FE1CB), fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: uid == null 
                      ? _EmptyState() 
                      : userRole == 'donor' 
                          ? _buildDonorRequests(uid)
                          : _buildRecipientNotifications(uid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorRequests(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Requests').where('DonorId', isEqualTo: uid).where('Status', isEqualTo: 'Pending').orderBy('CreatedAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(20), child: SelectableText('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red))));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return _EmptyState();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: FSizzes.defaultSpace),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;
            return _RequestTile(data: data, docId: docId);
          },
        );
      },
    );
  }
  Widget _buildRecipientNotifications(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Requests').where('RecipientId', isEqualTo: uid).where('Status', whereIn: ['Accepted', 'Rejected']).orderBy('CreatedAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(20), child: SelectableText('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red))));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return _EmptyState();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: FSizzes.defaultSpace),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return _RecipientNotificationTile(data: data);
          },
        );
      },
    );
  }
}

class _RecipientNotificationTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RecipientNotificationTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data['Status'];
    final isAccepted = status == 'Accepted';
    final iconColor = isAccepted ? const Color(0xFF1D9E75) : const Color(0xFFC62828);
    final icon = isAccepted ? Iconsax.tick_circle : Iconsax.close_circle;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: iconColor.withOpacity(0.3)),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isAccepted ? 'Request Accepted!' : 'Request Rejected', style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(isAccepted ? 'Your request for "${data['FoodName']}" has been accepted by the donor. Please proceed to pickup.' : 'Your request for "${data['FoodName']}" was rejected.', style: TextStyle(color: const Color(0xFF5DCAA5).withOpacity(0.8), fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  const _RequestTile({required this.data, required this.docId});

  void _accept() async {
    final listingId = data['ListingId'];
    if (listingId == null) return;

    // Update Request to Accepted
    await FirebaseFirestore.instance.collection('Requests').doc(docId).update({'Status': 'Accepted'});
    
    // Update Listing to Confirmed
    await FirebaseFirestore.instance.collection('FoodListings').doc(listingId).update({
      'Status': 'Confirmed',
      'ClaimedBy': data['RecipientId'],
      'ClaimedByName': data['RecipientName'],
    });

    // Automatically reject all other pending requests for the same listing
    final otherRequests = await FirebaseFirestore.instance.collection('Requests').where('ListingId', isEqualTo: listingId).where('Status', isEqualTo: 'Pending').get();
    final batch = FirebaseFirestore.instance.batch();
    for (var doc in otherRequests.docs) {
      if (doc.id != docId) {
        batch.update(doc.reference, {'Status': 'Rejected'});
      }
    }
    await batch.commit();

    Get.snackbar('Accepted', 'Food request accepted. Other requests rejected.', backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _reject() async {
    await FirebaseFirestore.instance.collection('Requests').doc(docId).update({'Status': 'Rejected'});
    Get.snackbar('Rejected', 'Food request rejected.', backgroundColor: Colors.red, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1D9E75).withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF9F27).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEF9F27).withOpacity(0.3)),
                ),
                child: const Icon(Iconsax.message_question, color: Color(0xFFEF9F27), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('New Food Request', style: TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('${data['RecipientName']} requested "${data['FoodName']}"', style: TextStyle(color: const Color(0xFF5DCAA5).withOpacity(0.8), fontSize: 12, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reject,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Reject', style: TextStyle(color: Colors.redAccent)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _accept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF9F27),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
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
              color: const Color(0xFF0F6E56).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.notification, color: const Color(0xFF1D9E75).withOpacity(0.5), size: 36),
          ),
          const SizedBox(height: 16),
          const Text('No new requests', style: TextStyle(color: Color(0xFF9FE1CB), fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('You\'re all caught up!', style: TextStyle(color: const Color(0xFF5DCAA5).withOpacity(0.6), fontSize: 13)),
        ],
      ),
    );
  }
}