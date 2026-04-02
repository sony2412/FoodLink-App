import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotifData> _notifications = [
    _NotifData(
      icon: Iconsax.tick_circle,
      iconColor: Color(0xFF1D9E75),
      title: 'Claim Approved!',
      body: 'Your claim for "Biryani & Dal" from Spice Garden has been approved.',
      time: '2 min ago',
      isRead: false,
      type: _NotifType.claim,
    ),
    _NotifData(
      icon: Iconsax.clock,
      iconColor: Color(0xFFEF9F27),
      title: 'Expiring Soon',
      body: '"Assorted Bakery Items" you saved is expiring in 2 hours. Claim now!',
      time: '15 min ago',
      isRead: false,
      type: _NotifType.expiry,
    ),
    _NotifData(
      icon: Iconsax.add_circle,
      iconColor: Color(0xFF5DCAA5),
      title: 'New Listing Nearby',
      body: 'Green Farms just posted 8kg of fresh vegetables 2.1 km from you.',
      time: '1 hr ago',
      isRead: false,
      type: _NotifType.newListing,
    ),
    _NotifData(
      icon: Iconsax.truck,
      iconColor: Color(0xFF9FE1CB),
      title: 'Delivery Assigned',
      body: 'A volunteer has been assigned to deliver your claim. ETA: 30 mins.',
      time: '3 hrs ago',
      isRead: true,
      type: _NotifType.delivery,
    ),
    _NotifData(
      icon: Iconsax.star,
      iconColor: Color(0xFFEF9F27),
      title: 'You earned a badge!',
      body: 'Congratulations! You\'ve earned the "Food Hero" badge for 50 claims.',
      time: 'Yesterday',
      isRead: true,
      type: _NotifType.badge,
    ),
    _NotifData(
      icon: Iconsax.add_circle,
      iconColor: Color(0xFF5DCAA5),
      title: 'New Listing Nearby',
      body: 'Daily Bread Bakery posted 30 assorted bakery items near you.',
      time: 'Yesterday',
      isRead: true,
      type: _NotifType.newListing,
    ),
    _NotifData(
      icon: Iconsax.close_circle,
      iconColor: Color(0xFFC62828),
      title: 'Claim Rejected',
      body: 'Your claim for "Rice & Curry" was rejected. The food has been claimed by another recipient.',
      time: '2 days ago',
      isRead: true,
      type: _NotifType.claim,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0D3D30),
      body: Stack(
        children: [
          // Ambient blob — top left
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
          // Ambient blob — bottom right
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
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              FTexts.notifications,
                              style: TextStyle(
                                color: Color(0xFF9FE1CB),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (unreadCount > 0) ...[
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFEF9F27), Color(0xFFBA7517)],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$unreadCount new',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (unreadCount > 0)
                        GestureDetector(
                          onTap: _markAllRead,
                          child: const Text(
                            FTexts.markAllRead,
                            style: TextStyle(
                              color: Color(0xFFEF9F27),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // List
                Expanded(
                  child: _notifications.isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: FSizzes.defaultSpace),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final n = _notifications[index];
                      // Section header for "Earlier"
                      final showHeader = index == 3;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            _SectionHeader(title: 'Recent'),
                          if (showHeader)
                            _SectionHeader(title: 'Earlier'),
                          _NotifTile(
                            data: n,
                            onTap: () {
                              setState(() => n.isRead = true);
                            },
                            onDismiss: () {
                              setState(() => _notifications.removeAt(index));
                            },
                          ),
                        ],
                      );
                    },
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

// ── NOTIFICATION TILE ─────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  const _NotifTile({
    required this.data,
    required this.onTap,
    required this.onDismiss,
  });

  final _NotifData data;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFC62828).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Iconsax.trash, color: Color(0xFFC62828), size: 22),
      ),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: data.isRead
                ? const Color(0xFF0F6E56).withValues(alpha: 0.08)
                : const Color(0xFF0F6E56).withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: data.isRead
                  ? const Color(0xFF1D9E75).withValues(alpha: 0.15)
                  : const Color(0xFF1D9E75).withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: data.iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: data.iconColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(data.icon, color: data.iconColor, size: 20),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.title,
                            style: TextStyle(
                              color: const Color(0xFF9FE1CB),
                              fontSize: 13,
                              fontWeight: data.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!data.isRead)
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF9F27),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.body,
                      style: TextStyle(
                        color: const Color(0xFF5DCAA5).withValues(alpha: 0.8),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.time,
                      style: TextStyle(
                        color: const Color(0xFF5DCAA5).withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
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
              color: const Color(0xFF0F6E56).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.notification,
              color: const Color(0xFF1D9E75).withValues(alpha: 0.5),
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            FTexts.noNotifications,
            style: TextStyle(
              color: Color(0xFF9FE1CB),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
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

enum _NotifType { claim, expiry, newListing, delivery, badge }

class _NotifData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  bool isRead;
  final _NotifType type;

  _NotifData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
  });
}