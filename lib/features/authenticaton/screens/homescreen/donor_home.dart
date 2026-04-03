import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../FindNGO/find_ngo.dart';
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
    _DonorListingsPage(),
    _DonorHistoryPage(),
    _DonorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2E22),
      body: _pages[_currentIndex],
      bottomNavigationBar: _DonorBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

//Donor Navigation bar
class _DonorBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DonorBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D3D30),
        border: Border(
          top: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.25), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
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
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1D9E75).withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF5DCAA5) : const Color(0xFF5DCAA5).withValues(alpha: 0.4),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? const Color(0xFF5DCAA5) : const Color(0xFF5DCAA5).withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Home Page
class _DonorHomePage extends StatelessWidget {
  const _DonorHomePage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ambient blobs
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 220,
            height: 220,
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
          top: 120,
          right: -40,
          child: Container(
            width: 160,
            height: 160,
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildImpactStats()),
              SliverToBoxAdapter(child: _buildQuickActions()),
              SliverToBoxAdapter(child: _buildActiveListings()),
              SliverToBoxAdapter(child: _buildNearbyRecipients()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning 👋',
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Rahul\'s Kitchen',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9FE1CB),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Notification bell
              GestureDetector(
                onTap: () => Get.to(() => const NotificationsScreen()),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.3)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Iconsax.notification, color: Color(0xFF5DCAA5), size: 20),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF9F27),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F6E56), Color(0xFF1D9E75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Impact This Month',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ImpactStat(icon: Iconsax.heart5, value: '142', label: 'Meals\nDonated'),
                _ImpactStat(icon: Iconsax.weight, value: '68 kg', label: 'Food\nSaved'),
                _ImpactStat(icon: Iconsax.people, value: '31', label: 'People\nHelped'),
                _ImpactStat(icon: Iconsax.tree, value: '12 kg', label: 'CO₂\nReduced'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Iconsax.add_circle,
                  label: 'Post Food',
                  subtitle: 'List surplus food',
                  color: const Color(0xFFEF9F27),
                  onTap: () => Get.to(() => const PostFoodScreen()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Iconsax.location,
                  label: 'Find NGOs',
                  subtitle: 'Nearby recipients',
                  color: const Color(0xFF5DCAA5),
                  onTap: ()  => Get.to(() => const FindNGOsScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveListings() {
    // Mock data
    final listings = [
      {'title': 'Cooked Rice & Dal', 'qty': '5 kg', 'expires': '2h left', 'status': 'Available', 'claimed': false},
      {'title': 'Fresh Bread Loaves', 'qty': '12 pcs', 'expires': '5h left', 'status': 'Claimed', 'claimed': true},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Listings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See all', style: TextStyle(color: Color(0xFFEF9F27), fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...listings.map((l) => _ListingCard(listing: l)),
          if (listings.isEmpty)
            _EmptyState(
              icon: Iconsax.box,
              message: 'No active listings yet.\nTap "Post Food" to get started!',
            ),
        ],
      ),
    );
  }

  Widget _buildNearbyRecipients() {
    final recipients = [
      {'name': 'Aasha NGO', 'distance': '1.2 km', 'type': 'Shelter', 'needs': 'Cooked meals'},
      {'name': 'Bal Vikas Trust', 'distance': '2.8 km', 'type': 'Children\'s Home', 'needs': 'Any food'},
      {'name': 'City Food Bank', 'distance': '3.5 km', 'type': 'Food Bank', 'needs': 'Raw ingredients'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby Recipients',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Map view', style: TextStyle(color: Color(0xFFEF9F27), fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...recipients.map((r) => _RecipientCard(recipient: r)),
        ],
      ),
    );
  }
}


class _ImpactStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ImpactStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10), textAlign: TextAlign.center),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0F2E20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Map<String, dynamic> listing;

  const _ListingCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    final isClaimed = listing['claimed'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2E20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Iconsax.box, color: Color(0xFF5DCAA5), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing['title'] as String,
                    style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text('${listing['qty']} • ${listing['expires']}',
                    style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.7), fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isClaimed
                  ? const Color(0xFFEF9F27).withValues(alpha: 0.15)
                  : const Color(0xFF1D9E75).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isClaimed
                    ? const Color(0xFFEF9F27).withValues(alpha: 0.4)
                    : const Color(0xFF1D9E75).withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              listing['status'] as String,
              style: TextStyle(
                color: isClaimed ? const Color(0xFFEF9F27) : const Color(0xFF5DCAA5),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipientCard extends StatelessWidget {
  final Map<String, dynamic> recipient;

  const _RecipientCard({required this.recipient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2E20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF5DCAA5).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Iconsax.building, color: Color(0xFF5DCAA5), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipient['name'] as String,
                    style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text('${recipient['type']} • Needs: ${recipient['needs']}',
                    style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.7), fontSize: 11)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Iconsax.location, color: Color(0xFFEF9F27), size: 13),
              const SizedBox(width: 3),
              Text(recipient['distance'] as String,
                  style: const TextStyle(color: Color(0xFFEF9F27), fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2E20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF5DCAA5).withValues(alpha: 0.4), size: 36),
          const SizedBox(height: 10),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}


class _DonorListingsPage extends StatelessWidget {
  const _DonorListingsPage();

  @override
  Widget build(BuildContext context) {
    final tabs = ['Active', 'Claimed', 'Expired'];
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Positioned(
            top: -60, left: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF0F6E56).withValues(alpha: 0.3), Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Listings',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB))),
                      GestureDetector(
                        onTap: ()  => Get.to(() => const PostFoodScreen()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Iconsax.add, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text('Post Food', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  labelColor: const Color(0xFF5DCAA5),
                  unselectedLabelColor: const Color(0xFF5DCAA5).withValues(alpha: 0.4),
                  indicatorColor: const Color(0xFF5DCAA5),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  dividerColor: Colors.transparent,
                  tabs: tabs.map((t) => Tab(text: t)).toList(),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TabBarView(
                    children: [
                      _ListingsTabContent(status: 'Active'),
                      _ListingsTabContent(status: 'Claimed'),
                      _ListingsTabContent(status: 'Expired'),
                    ],
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

class _ListingsTabContent extends StatelessWidget {
  final String status;
  const _ListingsTabContent({required this.status});

  @override
  Widget build(BuildContext context) {
    // Mock listings
    final allListings = [
      {'title': 'Cooked Rice & Dal', 'qty': '5 kg', 'expires': '2h left', 'status': 'Active', 'category': 'Cooked Food', 'claimed': false},
      {'title': 'Fresh Bread Loaves', 'qty': '12 pcs', 'expires': '5h left', 'status': 'Claimed', 'category': 'Bakery', 'claimed': true},
      {'title': 'Mixed Vegetables', 'qty': '3 kg', 'expires': 'Expired', 'status': 'Expired', 'category': 'Vegetables', 'claimed': false},
    ];
    final filtered = allListings.where((l) => l['status'] == status).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.box, color: const Color(0xFF5DCAA5).withValues(alpha: 0.3), size: 48),
            const SizedBox(height: 12),
            Text('No $status listings', style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.5), fontSize: 14)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final l = filtered[i];
        final isClaimed = l['claimed'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2E20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l['title'] as String,
                      style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 14, fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isClaimed
                          ? const Color(0xFFEF9F27).withValues(alpha: 0.15)
                          : status == 'Expired'
                          ? Colors.red.withValues(alpha: 0.1)
                          : const Color(0xFF1D9E75).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isClaimed
                            ? const Color(0xFFEF9F27).withValues(alpha: 0.4)
                            : status == 'Expired'
                            ? Colors.red.withValues(alpha: 0.3)
                            : const Color(0xFF1D9E75).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      l['status'] as String,
                      style: TextStyle(
                        color: isClaimed
                            ? const Color(0xFFEF9F27)
                            : status == 'Expired'
                            ? Colors.redAccent
                            : const Color(0xFF5DCAA5),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _InfoChip(icon: Iconsax.weight, label: l['qty'] as String),
                  const SizedBox(width: 8),
                  _InfoChip(icon: Iconsax.tag, label: l['category'] as String),
                  const SizedBox(width: 8),
                  _InfoChip(icon: Iconsax.clock, label: l['expires'] as String),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5DCAA5),
                        side: BorderSide(color: const Color(0xFF1D9E75).withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Edit', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: BorderSide(color: Colors.red.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Remove', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5DCAA5).withValues(alpha: 0.6), size: 12),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.7), fontSize: 11)),
      ],
    );
  }
}


class _DonorHistoryPage extends StatelessWidget {
  const _DonorHistoryPage();

  @override
  Widget build(BuildContext context) {
    final history = [
      {'title': 'Biryani (Large Batch)', 'qty': '8 kg', 'date': 'Mar 29, 2026', 'meals': '32', 'recipient': 'Aasha NGO'},
      {'title': 'Packaged Biscuits', 'qty': '20 packs', 'date': 'Mar 27, 2026', 'meals': '20', 'recipient': 'City Food Bank'},
      {'title': 'Fresh Fruits', 'qty': '4 kg', 'date': 'Mar 25, 2026', 'meals': '16', 'recipient': 'Bal Vikas Trust'},
      {'title': 'Roti & Sabzi', 'qty': '6 kg', 'date': 'Mar 22, 2026', 'meals': '24', 'recipient': 'Individual'},
    ];

    return Stack(
      children: [
        Positioned(
          bottom: 80, right: -40,
          child: Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFFBA7517).withValues(alpha: 0.2), Colors.transparent,
              ]),
            ),
          ),
        ),
        SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: const Text('Donation History',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB))),
                ),
              ),
              // Monthly summary card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2E20),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _HistoryStat(value: '142', label: 'Total Meals'),
                        _HistoryStat(value: '68 kg', label: 'Food Saved'),
                        _HistoryStat(value: '31', label: 'Families'),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text('Past Donations',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF9FE1CB))),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                    final h = history[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F2E20),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Iconsax.tick_circle, color: Color(0xFF5DCAA5), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(h['title'] as String,
                                      style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 3),
                                  Text('${h['qty']} → ${h['recipient']}',
                                      style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.7), fontSize: 11)),
                                  Text(h['date'] as String,
                                      style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.5), fontSize: 10)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${h['meals']}',
                                    style: const TextStyle(color: Color(0xFFEF9F27), fontSize: 16, fontWeight: FontWeight.w700)),
                                const Text('meals', style: TextStyle(color: Color(0xFFEF9F27), fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: history.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryStat extends StatelessWidget {
  final String value;
  final String label;
  const _HistoryStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.7), fontSize: 11)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  PROFILE PAGE
// ─────────────────────────────────────────────
class _DonorProfilePage extends StatelessWidget {
  const _DonorProfilePage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60, left: -60,
          child: Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFF0F6E56).withValues(alpha: 0.3), Colors.transparent,
              ]),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Avatar + name
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
                    ),
                  ),
                  child: const Center(
                    child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 28)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Rahul\'s Kitchen',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF9FE1CB))),
                const SizedBox(height: 4),
                Text('Food Donor', style: TextStyle(color: const Color(0xFF5DCAA5).withValues(alpha: 0.7), fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF9F27).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFEF9F27).withValues(alpha: 0.4)),
                  ),
                  child: const Text('⭐ Top Donor', style: TextStyle(color: Color(0xFFEF9F27), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 24),
                // Profile options
                _ProfileOption(icon: Iconsax.user_edit, label: 'Edit Profile', onTap: () => Get.to(() => EditProfileScreen(role: 'donor'))),
                _ProfileOption(icon: Iconsax.notification, label: 'Notifications', onTap: () => Get.to(() => const NotificationsScreen())),
                _ProfileOption(icon: Iconsax.location, label: 'My Location', onTap: () {}),
                _ProfileOption(icon: Iconsax.security, label: 'Privacy & Security', onTap: () {}),
                _ProfileOption(icon: Iconsax.info_circle, label: 'About FoodLink', onTap: () {}),
                const SizedBox(height: 8),
                // Logout
                GestureDetector(
                  onTap: () => Get.offAll(() => const LoginScreen()),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.logout, color: Colors.redAccent, size: 18),
                        SizedBox(width: 8),
                        Text('Log Out', style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0F2E20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1D9E75).withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5DCAA5), size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: const TextStyle(color: Color(0xFF9FE1CB), fontSize: 13, fontWeight: FontWeight.w500)),
            ),
            Icon(Iconsax.arrow_right_3, color: const Color(0xFF5DCAA5).withValues(alpha: 0.4), size: 16),
          ],
        ),
      ),
    );
  }
}