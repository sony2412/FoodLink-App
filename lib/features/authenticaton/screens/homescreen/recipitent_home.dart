import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
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
    _BrowseTab(),
    _MyClaimsTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: _tabs[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF091F17),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFEF9F27),
        unselectedItemColor: const Color(0xFF5DCAA5).withValues(alpha: 0.5),
        selectedLabelStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.search_normal), label: 'Browse'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.heart), label: 'My Claims'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}

// ── HOME TAB ──────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: FSizzes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FTexts.homeAppbarTitle,
                      style: const TextStyle(
                        color: Color(0xFF5DCAA5),
                        fontSize: 13,
                      ),
                    ),
                    const Text(
                      'Hello, Sarah 👋',
                      style: TextStyle(
                        color: Color(0xFF9FE1CB),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _IconBtn(icon: Iconsax.notification, onTap: () => Get.to(() => const NotificationsScreen())),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF0F6E56),
                      child: const Text('S',
                          style: TextStyle(
                              color: Color(0xFF9FE1CB),
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Search bar
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
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
                    Text(
                      'Search food near you...',
                      style: TextStyle(
                        color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Urgency banner — expiring soon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFBA7517).withValues(alpha: 0.3),
                    const Color(0xFFEF9F27).withValues(alpha: 0.15),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEF9F27).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF9F27).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Iconsax.clock,
                        color: Color(0xFFEF9F27), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '3 listings expiring soon!',
                          style: TextStyle(
                            color: Color(0xFFFAC775),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Claim before they\'re gone',
                          style: TextStyle(
                            color: const Color(0xFFEF9F27)
                                .withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const FoodDetailScreen()),
                    child: const Text(
                      'View →',
                      style: TextStyle(
                        color: Color(0xFFEF9F27),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Categories
            const Text(
              'Food Categories',
              style: TextStyle(
                color: Color(0xFF9FE1CB),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _CategoryChip(label: FTexts.categoryAll, icon: Iconsax.category, isSelected: true),
                  _CategoryChip(label: FTexts.categoryCooked, icon: Iconsax.cake),
                  _CategoryChip(label: FTexts.categoryFruits, icon: Iconsax.health),
                  _CategoryChip(label: FTexts.categoryBakery, icon: Iconsax.cake),
                  _CategoryChip(label: FTexts.categoryDairy, icon: Iconsax.cup),
                  _CategoryChip(label: FTexts.categoryPackaged, icon: Iconsax.box),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Available Food Nearby
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  FTexts.nearbyListings,
                  style: TextStyle(
                    color: Color(0xFF9FE1CB),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const FoodDetailScreen()),
                  child: const Text(
                    FTexts.viewAll,
                    style: TextStyle(
                      color: Color(0xFFEF9F27),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _FoodCard(
              title: 'Biryani & Dal',
              donor: 'Spice Garden Restaurant',
              distance: '0.8 km',
              quantity: '15 plates',
              category: FTexts.categoryCooked,
              expiresIn: '2 hrs',
              isUrgent: true,
            ),
            _FoodCard(
              title: 'Assorted Bakery Items',
              donor: 'Daily Bread Bakery',
              distance: '1.2 km',
              quantity: '30 pieces',
              category: FTexts.categoryBakery,
              expiresIn: '5 hrs',
              isUrgent: false,
            ),
            _FoodCard(
              title: 'Fresh Vegetables',
              donor: 'Green Farms',
              distance: '2.1 km',
              quantity: '8 kg',
              category: FTexts.categoryFruits,
              expiresIn: 'Tomorrow',
              isUrgent: false,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── BROWSE TAB ────────────────────────────────────────────────────────────────

class _BrowseTab extends StatefulWidget {
  const _BrowseTab();

  @override
  State<_BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<_BrowseTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                FSizzes.defaultSpace, 20, FSizzes.defaultSpace, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  FTexts.mapTitle,
                  style: TextStyle(
                    color: Color(0xFF9FE1CB),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  FTexts.homeAppbarSubTitle,
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),

                /// Tab bar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                      ),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF5DCAA5),
                    labelStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'List View'),
                      Tab(text: 'Map View'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// List view
                ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: FSizzes.defaultSpace),
                  children: [
                    _FoodCard(
                      title: 'Biryani & Dal',
                      donor: 'Spice Garden Restaurant',
                      distance: '0.8 km',
                      quantity: '15 plates',
                      category: FTexts.categoryCooked,
                      expiresIn: '2 hrs',
                      isUrgent: true,
                    ),
                    _FoodCard(
                      title: 'Assorted Bakery Items',
                      donor: 'Daily Bread Bakery',
                      distance: '1.2 km',
                      quantity: '30 pieces',
                      category: FTexts.categoryBakery,
                      expiresIn: '5 hrs',
                      isUrgent: false,
                    ),
                    _FoodCard(
                      title: 'Fresh Vegetables',
                      donor: 'Green Farms',
                      distance: '2.1 km',
                      quantity: '8 kg',
                      category: FTexts.categoryFruits,
                      expiresIn: 'Tomorrow',
                      isUrgent: false,
                    ),
                    _FoodCard(
                      title: 'Packaged Snacks',
                      donor: 'SuperMart',
                      distance: '3.4 km',
                      quantity: '50 packets',
                      category: FTexts.categoryPackaged,
                      expiresIn: '3 days',
                      isUrgent: false,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

                /// Map placeholder
                Container(
                  margin: const EdgeInsets.all(FSizzes.defaultSpace),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.location,
                          color: const Color(0xFF1D9E75).withValues(alpha: 0.5),
                          size: 64),
                      const SizedBox(height: 16),
                      const Text(
                        FTexts.mapTitle,
                        style: TextStyle(
                          color: Color(0xFF9FE1CB),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Google Maps integration\ncoming soon',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
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

// ── MY CLAIMS TAB ─────────────────────────────────────────────────────────────

class _MyClaimsTab extends StatefulWidget {
  const _MyClaimsTab();

  @override
  State<_MyClaimsTab> createState() => _MyClaimsTabState();
}

class _MyClaimsTabState extends State<_MyClaimsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                FSizzes.defaultSpace, 20, FSizzes.defaultSpace, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  FTexts.myClaimedFood,
                  style: TextStyle(
                    color: Color(0xFF9FE1CB),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                      ),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF5DCAA5),
                    labelStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Active Requests'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// Active requests
                ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: FSizzes.defaultSpace),
                  children: [
                    _ClaimCard(
                      foodName: 'Biryani & Dal',
                      donor: 'Spice Garden Restaurant',
                      quantity: '10 plates',
                      status: FTexts.claimPending,
                      statusColor: const Color(0xFFEF9F27),
                      claimedOn: 'Today, 2:30 PM',
                    ),
                    _ClaimCard(
                      foodName: 'Assorted Bakery Items',
                      donor: 'Daily Bread Bakery',
                      quantity: '20 pieces',
                      status: FTexts.claimApproved,
                      statusColor: const Color(0xFF1D9E75),
                      claimedOn: 'Today, 11:00 AM',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

                /// History
                ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: FSizzes.defaultSpace),
                  children: [
                    _ClaimCard(
                      foodName: 'Fresh Vegetables',
                      donor: 'Green Farms',
                      quantity: '5 kg',
                      status: 'Received',
                      statusColor: const Color(0xFF5DCAA5),
                      claimedOn: 'Yesterday, 4:00 PM',
                    ),
                    _ClaimCard(
                      foodName: 'Packaged Snacks',
                      donor: 'SuperMart',
                      quantity: '30 packets',
                      status: 'Received',
                      statusColor: const Color(0xFF5DCAA5),
                      claimedOn: 'Mar 28, 3:00 PM',
                    ),
                    _ClaimCard(
                      foodName: 'Rice & Curry',
                      donor: 'Home Cook — Priya',
                      quantity: '8 plates',
                      status: FTexts.claimRejected,
                      statusColor: const Color(0xFFC62828),
                      claimedOn: 'Mar 26, 1:00 PM',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── PROFILE TAB ───────────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: FSizzes.defaultSpace),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Avatar + name
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: const Color(0xFF0F6E56),
                        child: const Text(
                          'S',
                          style: TextStyle(
                            color: Color(0xFF9FE1CB),
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF0D3D30), width: 2),
                          ),
                          child: const Icon(Iconsax.edit,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sarah Johnson',
                    style: TextStyle(
                      color: Color(0xFF9FE1CB),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Text(
                      FTexts.roleRecipient,
                      style: TextStyle(
                        color: Color(0xFF5DCAA5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Stats row
            Row(
              children: [
                _StatCard(
                  label: FTexts.totalClaimed,
                  value: '47',
                  icon: Iconsax.heart,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: FTexts.mealsShared,
                  value: '120',
                  icon: Iconsax.cake,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: FTexts.impactScore,
                  value: '890',
                  icon: Iconsax.star,
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// Menu items
            _MenuSection(title: 'Account', items: [
              _MenuItem(icon: Iconsax.user, label: FTexts.editProfile, onTap: () => Get.to(() => EditProfileScreen(role: 'donor'))),
              _MenuItem(icon: Iconsax.heart, label: FTexts.savedListings, onTap: () {}),
              _MenuItem(icon: Iconsax.notification, label: FTexts.notificationSettings, onTap: () => Get.to(() => const NotificationsScreen())),
            ]),
            const SizedBox(height: 16),
            _MenuSection(title: 'App', items: [
              _MenuItem(icon: Iconsax.moon, label: FTexts.darkMode, onTap: () {}),
              _MenuItem(icon: Iconsax.global, label: FTexts.languageSettings, onTap: () {}),
              _MenuItem(icon: Iconsax.info_circle, label: FTexts.helpSupport, onTap: () {}),
              _MenuItem(icon: Iconsax.document, label: FTexts.privacyPolicy, onTap: () {}),
            ]),
            const SizedBox(height: 16),

            /// Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.offAll(() => const LoginScreen()),
                icon: const Icon(Iconsax.logout,
                    color: Color(0xFFC62828), size: 18),
                label: Text(
                  FTexts.logout,
                  style: const TextStyle(color: Color(0xFFC62828)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFFC62828), width: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── REUSABLE WIDGETS ──────────────────────────────────────────────────────────

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.title,
    required this.donor,
    required this.distance,
    required this.quantity,
    required this.category,
    required this.expiresIn,
    required this.isUrgent,
  });

  final String title, donor, distance, quantity, category, expiresIn;
  final bool isUrgent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const FoodDetailScreen()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUrgent
                ? const Color(0xFFEF9F27).withValues(alpha: 0.4)
                : const Color(0xFF1D9E75).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF9FE1CB),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF9F27).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFEF9F27).withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Text(
                      'Urgent',
                      style: TextStyle(
                        color: Color(0xFFEF9F27),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              donor,
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Tag(icon: Iconsax.location, label: distance),
                const SizedBox(width: 8),
                _Tag(icon: Iconsax.box, label: quantity),
                const SizedBox(width: 8),
                _Tag(icon: Iconsax.clock, label: expiresIn,
                    color: isUrgent ? const Color(0xFFEF9F27) : null),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => const FoodDetailScreen()),
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
                          FTexts.claimNow,
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
                const SizedBox(width: 8),
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
                    child: const Icon(Iconsax.heart,
                        color: Color(0xFF5DCAA5), size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({
    required this.foodName,
    required this.donor,
    required this.quantity,
    required this.status,
    required this.statusColor,
    required this.claimedOn,
  });

  final String foodName, donor, quantity, status, claimedOn;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF0F6E56).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Iconsax.cake,
                color: Color(0xFF5DCAA5), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodName,
                  style: const TextStyle(
                    color: Color(0xFF9FE1CB),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  donor,
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$quantity • $claimedOn',
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  final String label;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
          colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
        )
            : null,
        color: isSelected
            ? null
            : const Color(0xFF0F6E56).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : const Color(0xFF1D9E75).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: isSelected ? Colors.white : const Color(0xFF5DCAA5),
              size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF5DCAA5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF5DCAA5);
    return Row(
      children: [
        Icon(icon, color: c.withValues(alpha: 0.7), size: 12),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: c.withValues(alpha: 0.9),
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
          ),
        ),
        child: Icon(icon, color: const Color(0xFF5DCAA5), size: 20),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFEF9F27), size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF9FE1CB),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
            ),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF1D9E75).withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5DCAA5), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF9FE1CB),
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              color: const Color(0xFF5DCAA5).withValues(alpha: 0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}