import 'package:flutter/material.dart';
import 'package:foodlink/common/widgets/f_screen_background.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../NotificationScreen/notification_screen.dart';
import '../ProfileScreen/profile_screen.dart';
import '../login/login.dart';

class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    _HomeTab(),
    _TasksTab(),
    _MyDeliveriesTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Let FScreenBackground show through
      body: FScreenBackground(
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: Container(
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
                icon: Icon(Iconsax.task_square), label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.truck), label: 'Deliveries'),
            BottomNavigationBarItem(
                icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
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
                    const Text(
                      FTexts.volunteerMode,
                      style: TextStyle(
                        color: Color(0xFF5DCAA5),
                        fontSize: 13,
                      ),
                    ),
                    const Text(
                      'Hey, Ravi 🚴',
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

                    /// Online/offline toggle
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Active delivery card (if any)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1D9E75).withValues(alpha: 0.25),
                    const Color(0xFF0F6E56).withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Iconsax.truck,
                            color: Color(0xFF5DCAA5), size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        FTexts.deliveryInProgress,
                        style: TextStyle(
                          color: Color(0xFF9FE1CB),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF9F27).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'In Progress',
                          style: TextStyle(
                            color: Color(0xFFEF9F27),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const _DeliveryStep(
                    icon: Iconsax.cake,
                    label: 'Pickup',
                    detail: 'Spice Garden Restaurant — 0.8 km',
                    isDone: true,
                  ),
                  const SizedBox(height: 8),
                  const _DeliveryStep(
                    icon: Iconsax.heart,
                    label: 'Deliver to',
                    detail: 'City Shelter NGO — 2.3 km',
                    isDone: false,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFEF9F27),
                                  Color(0xFFBA7517)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                FTexts.deliveryCompleted,
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
                            color: const Color(0xFF0F6E56)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF1D9E75)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(Iconsax.location,
                              color: Color(0xFF5DCAA5), size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Impact stats
            Row(
              children: [
                _SmallStatCard(
                    label: 'Today',
                    value: '3',
                    sublabel: 'Deliveries',
                    icon: Iconsax.truck),
                const SizedBox(width: 12),
                _SmallStatCard(
                    label: 'This Week',
                    value: '18',
                    sublabel: 'Deliveries',
                    icon: Iconsax.calendar),
                const SizedBox(width: 12),
                _SmallStatCard(
                    label: FTexts.impactScore,
                    value: '1.2k',
                    sublabel: 'Points',
                    icon: Iconsax.star),
              ],
            ),
            const SizedBox(height: 24),

            /// Available tasks near you
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  FTexts.availableDeliveries,
                  style: TextStyle(
                    color: Color(0xFF9FE1CB),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
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

            _TaskCard(
              foodName: 'Fresh Vegetables',
              from: 'Green Farms',
              to: 'City Shelter NGO',
              distance: '3.1 km',
              quantity: '8 kg',
              reward: '50 pts',
            ),
            _TaskCard(
              foodName: 'Assorted Bakery',
              from: 'Daily Bread Bakery',
              to: 'Hope Foundation',
              distance: '1.8 km',
              quantity: '30 pieces',
              reward: '35 pts',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── TASKS TAB ─────────────────────────────────────────────────────────────────

class _TasksTab extends StatelessWidget {
  const _TasksTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
                FSizzes.defaultSpace, 20, FSizzes.defaultSpace, 0),
            child: Text(
              FTexts.availableDeliveries,
              style: TextStyle(
                color: Color(0xFF9FE1CB),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: FSizzes.defaultSpace),
            child: Text(
              'Pickup tasks near you',
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: FSizzes.defaultSpace),
              children: [
                _TaskCard(
                  foodName: 'Fresh Vegetables',
                  from: 'Green Farms',
                  to: 'City Shelter NGO',
                  distance: '3.1 km',
                  quantity: '8 kg',
                  reward: '50 pts',
                ),
                _TaskCard(
                  foodName: 'Assorted Bakery',
                  from: 'Daily Bread Bakery',
                  to: 'Hope Foundation',
                  distance: '1.8 km',
                  quantity: '30 pieces',
                  reward: '35 pts',
                ),
                _TaskCard(
                  foodName: 'Packaged Snacks',
                  from: 'SuperMart',
                  to: 'Sunrise NGO',
                  distance: '4.2 km',
                  quantity: '50 packets',
                  reward: '60 pts',
                ),
                _TaskCard(
                  foodName: 'Rice & Curry',
                  from: 'Home Cook — Priya',
                  to: 'Children\'s Home',
                  distance: '2.5 km',
                  quantity: '12 plates',
                  reward: '40 pts',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── MY DELIVERIES TAB ─────────────────────────────────────────────────────────

class _MyDeliveriesTab extends StatefulWidget {
  const _MyDeliveriesTab();

  @override
  State<_MyDeliveriesTab> createState() => _MyDeliveriesTabState();
}

class _MyDeliveriesTabState extends State<_MyDeliveriesTab>
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
                  FTexts.deliveryHistory,
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
                      Tab(text: 'Active'),
                      Tab(text: 'Completed'),
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
                /// Active deliveries
                ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: FSizzes.defaultSpace),
                  children: [
                    _DeliveryHistoryCard(
                      foodName: 'Biryani & Dal',
                      from: 'Spice Garden Restaurant',
                      to: 'City Shelter NGO',
                      status: FTexts.deliveryInProgress,
                      statusColor: const Color(0xFFEF9F27),
                      date: 'Today, 3:00 PM',
                      points: '+45 pts',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

                /// Completed
                ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: FSizzes.defaultSpace),
                  children: [
                    _DeliveryHistoryCard(
                      foodName: 'Fresh Vegetables',
                      from: 'Green Farms',
                      to: 'City Shelter NGO',
                      status: FTexts.deliveryCompleted,
                      statusColor: const Color(0xFF1D9E75),
                      date: 'Yesterday, 5:00 PM',
                      points: '+50 pts',
                    ),
                    _DeliveryHistoryCard(
                      foodName: 'Bakery Items',
                      from: 'Daily Bread',
                      to: 'Hope Foundation',
                      status: FTexts.deliveryCompleted,
                      statusColor: const Color(0xFF1D9E75),
                      date: 'Mar 28, 2:00 PM',
                      points: '+35 pts',
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
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: const Color(0xFF0F6E56),
                        child: const Text(
                          'R',
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
                    'Ravi Sharma',
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
                      color: const Color(0xFFEF9F27).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFEF9F27).withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Text(
                      '⭐ Top Volunteer',
                      style: TextStyle(
                        color: Color(0xFFFAC775),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Impact stats
            Row(
              children: [
                _StatCard(
                    label: 'Total Deliveries',
                    value: '142',
                    icon: Iconsax.truck),
                const SizedBox(width: 12),
                _StatCard(
                    label: FTexts.mealsShared,
                    value: '430',
                    icon: Iconsax.cake),
                const SizedBox(width: 12),
                _StatCard(
                    label: FTexts.impactScore,
                    value: '3.4k',
                    icon: Iconsax.star),
              ],
            ),
            const SizedBox(height: 24),

            _MenuSection(title: 'Account', items: [
              _MenuItem(icon: Iconsax.user, label: FTexts.editProfile, onTap: () => Get.to(() => EditProfileScreen(role: 'volunteer'))),
              _MenuItem(icon: Iconsax.truck, label: FTexts.deliveryHistory, onTap: () {}),
              _MenuItem(icon: Iconsax.notification, label: FTexts.notificationSettings, onTap: () => Get.to(() => const NotificationsScreen())),
            ]),
            const SizedBox(height: 16),
            _MenuSection(title: 'App', items: [
              _MenuItem(icon: Iconsax.moon, label: FTexts.darkMode, onTap: () {}),
              _MenuItem(icon: Iconsax.info_circle, label: FTexts.helpSupport, onTap: () {}),
              _MenuItem(icon: Iconsax.document, label: FTexts.privacyPolicy, onTap: () {}),
            ]),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: ()  => Get.offAll(() => const LoginScreen()),
                icon: const Icon(Iconsax.logout,
                    color: Color(0xFFC62828), size: 18),
                label: Text(FTexts.logout,
                    style: const TextStyle(color: Color(0xFFC62828))),
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

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.foodName,
    required this.from,
    required this.to,
    required this.distance,
    required this.quantity,
    required this.reward,
  });

  final String foodName, from, to, distance, quantity, reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  foodName,
                  style: const TextStyle(
                    color: Color(0xFF9FE1CB),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  reward,
                  style: const TextStyle(
                    color: Color(0xFF5DCAA5),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Route
          Row(
            children: [
              const Icon(Iconsax.cake,
                  color: Color(0xFFEF9F27), size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  from,
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Container(
              width: 1, height: 12,
              color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
            ),
          ),
          Row(
            children: [
              const Icon(Iconsax.heart,
                  color: Color(0xFF5DCAA5), size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  to,
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _Tag(icon: Iconsax.location, label: distance),
              const SizedBox(width: 10),
              _Tag(icon: Iconsax.box, label: quantity),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {},
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
                    FTexts.acceptDelivery,
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
        ],
      ),
    );
  }
}

class _DeliveryHistoryCard extends StatelessWidget {
  const _DeliveryHistoryCard({
    required this.foodName,
    required this.from,
    required this.to,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.points,
  });

  final String foodName, from, to, status, date, points;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56).withValues(alpha: 0.15),
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
            child: const Icon(Iconsax.truck,
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
                  '$from → $to',
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                points,
                style: const TextStyle(
                  color: Color(0xFFEF9F27),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryStep extends StatelessWidget {
  const _DeliveryStep({
    required this.icon,
    required this.label,
    required this.detail,
    required this.isDone,
  });

  final IconData icon;
  final String label, detail;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: isDone
                ? const Color(0xFF1D9E75).withValues(alpha: 0.3)
                : const Color(0xFF0F6E56).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isDone ? Iconsax.tick_circle : icon,
            color: isDone ? const Color(0xFF5DCAA5) : const Color(0xFF5DCAA5).withValues(alpha: 0.5),
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDone
                    ? const Color(0xFF5DCAA5)
                    : const Color(0xFF9FE1CB),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              detail,
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  const _SmallStatCard({
    required this.label,
    required this.value,
    required this.sublabel,
    required this.icon,
  });

  final String label, value, sublabel;
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
            Icon(icon, color: const Color(0xFFEF9F27), size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF9FE1CB),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            color: const Color(0xFF5DCAA5).withValues(alpha: 0.7), size: 12),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.9),
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
            Text(value,
                style: const TextStyle(
                    color: Color(0xFF9FE1CB),
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xFF5DCAA5).withValues(alpha: 0.7),
                    fontSize: 10)),
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
          child: Text(title,
              style: TextStyle(
                  color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: const Color(0xFF1D9E75).withValues(alpha: 0.2)),
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
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: Text(label,
                  style: const TextStyle(
                      color: Color(0xFF9FE1CB), fontSize: 14)),
            ),
            Icon(Iconsax.arrow_right_3,
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.4),
                size: 16),
          ],
        ),
      ),
    );
  }
}
