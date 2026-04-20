import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';


class TrackDeliveryScreen extends StatefulWidget {
  const TrackDeliveryScreen({super.key});

  @override
  State<TrackDeliveryScreen> createState() => _TrackDeliveryScreenState();
}

class _TrackDeliveryScreenState extends State<TrackDeliveryScreen>
    with TickerProviderStateMixin {
  // 0 = Accepted, 1 = Picked Up, 2 = On the Way, 3 = Delivered
  int _currentStep = 2;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  final List<_StepData> _steps = [
    _StepData(
      icon: Iconsax.tick_circle,
      title: 'Order Accepted',
      subtitle: 'Volunteer accepted your claim',
      time: '3:15 PM',
    ),
    _StepData(
      icon: Iconsax.box,
      title: 'Food Picked Up',
      subtitle: 'Picked up from Spice Garden Restaurant',
      time: '3:32 PM',
    ),
    _StepData(
      icon: Iconsax.truck,
      title: 'On the Way',
      subtitle: 'Volunteer is heading to your location',
      time: '3:38 PM',
    ),
    _StepData(
      icon: Iconsax.home,
      title: 'Delivered',
      subtitle: 'Food delivered to your location',
      time: 'Est. 3:55 PM',
    ),
  ];

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
            bottom: 100, right: -60,
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
                              'Track Delivery',
                              style: TextStyle(
                                color: Color(0xFF9FE1CB),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Order #FL-2048',
                              style: TextStyle(
                                color: Color(0xFF5DCAA5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Live badge
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (_, __) => Opacity(
                          opacity: _pulseAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF1D9E75).withValues(alpha: 0.5),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Color(0xFF1D9E75)),
                                SizedBox(width: 5),
                                Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Color(0xFF5DCAA5),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: FSizzes.defaultSpace),
                    child: Column(
                      children: [

                        // ETA card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF0F6E56).withValues(alpha: 0.5),
                                const Color(0xFF1D9E75).withValues(alpha: 0.2),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF1D9E75).withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              // ETA
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Estimated Arrival',
                                      style: TextStyle(
                                        color: const Color(0xFF5DCAA5)
                                            .withValues(alpha: 0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '~17 min',
                                      style: TextStyle(
                                        color: Color(0xFF9FE1CB),
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Arriving by 3:55 PM',
                                      style: TextStyle(
                                        color: Color(0xFFEF9F27),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Distance
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F6E56)
                                      .withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Iconsax.location,
                                        color: Color(0xFFEF9F27), size: 24),
                                    const SizedBox(height: 6),
                                    const Text(
                                      '2.3 km',
                                      style: TextStyle(
                                        color: Color(0xFF9FE1CB),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'away',
                                      style: TextStyle(
                                        color: const Color(0xFF5DCAA5)
                                            .withValues(alpha: 0.7),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Map placeholder
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A2418),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Grid lines to simulate map
                              CustomPaint(
                                size: const Size(double.infinity, 180),
                                painter: _MapGridPainter(),
                              ),

                              // Route line simulation
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Donor pin
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEF9F27),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Iconsax.cake,
                                                  color: Colors.white,
                                                  size: 12),
                                              SizedBox(width: 4),
                                              Text(
                                                'Pickup',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Dashed route
                                        ...List.generate(
                                          8,
                                              (i) => Container(
                                            width: 6,
                                            height: 2,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            color: i < 6
                                                ? const Color(0xFF1D9E75)
                                                : const Color(0xFF1D9E75)
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Volunteer dot (animated)
                                        AnimatedBuilder(
                                          animation: _pulseController,
                                          builder: (_, __) => Container(
                                            width: 28, height: 28,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1D9E75),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF1D9E75)
                                                      .withValues(
                                                      alpha: _pulseAnimation
                                                          .value *
                                                          0.6),
                                                  blurRadius: 12,
                                                  spreadRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(Iconsax.truck,
                                                color: Colors.white, size: 14),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ...List.generate(
                                          4,
                                              (i) => Container(
                                            width: 6,
                                            height: 2,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            color: const Color(0xFF1D9E75)
                                                .withValues(alpha: 0.25),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Destination pin
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF5DCAA5),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Iconsax.home,
                                                  color: Colors.white,
                                                  size: 12),
                                              SizedBox(width: 4),
                                              Text(
                                                'You',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Map label
                              Positioned(
                                bottom: 10, right: 12,
                                child: Text(
                                  'Live Map — Coming Soon',
                                  style: TextStyle(
                                    color: const Color(0xFF5DCAA5)
                                        .withValues(alpha: 0.4),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Volunteer card
                        Container(
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
                              // Avatar
                              Container(
                                width: 52, height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0F6E56),
                                      Color(0xFF1D9E75)
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'R',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ravi Sharma',
                                      style: TextStyle(
                                        color: Color(0xFF9FE1CB),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Icon(Iconsax.star5,
                                            color: Color(0xFFEF9F27), size: 13),
                                        const SizedBox(width: 4),
                                        const Text(
                                          '4.9',
                                          style: TextStyle(
                                            color: Color(0xFFEF9F27),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '• 142 deliveries',
                                          style: TextStyle(
                                            color: const Color(0xFF5DCAA5)
                                                .withValues(alpha: 0.7),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Icon(Iconsax.driving,
                                            color: Color(0xFF5DCAA5), size: 12),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Two-Wheeler • MH31 AB 1234',
                                          style: TextStyle(
                                            color: const Color(0xFF5DCAA5)
                                                .withValues(alpha: 0.7),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Call button
                              GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                    'Calling Volunteer',
                                    'Connecting to Ravi Sharma...',
                                    backgroundColor: const Color(0xFF1D9E75),
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 12,
                                    icon: const Icon(Iconsax.call,
                                        color: Colors.white),
                                  );
                                },
                                child: Container(
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1D9E75),
                                        Color(0xFF0F6E56)
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF1D9E75)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Iconsax.call,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Order timeline
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Delivery Timeline',
                                style: TextStyle(
                                  color: Color(0xFF9FE1CB),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...List.generate(_steps.length, (i) {
                                final isDone = i <= _currentStep;
                                final isActive = i == _currentStep;
                                final isLast = i == _steps.length - 1;
                                return _TimelineStep(
                                  step: _steps[i],
                                  isDone: isDone,
                                  isActive: isActive,
                                  isLast: isLast,
                                  pulseAnimation: _pulseAnimation,
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Food summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F6E56).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF1D9E75).withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Summary',
                                style: TextStyle(
                                  color: Color(0xFF9FE1CB),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _SummaryRow(
                                  label: 'Food Item',
                                  value: 'Biryani & Dal'),
                              _SummaryRow(
                                  label: 'Donor',
                                  value: 'Spice Garden Restaurant'),
                              _SummaryRow(label: 'Quantity', value: '10 plates'),
                              _SummaryRow(
                                  label: 'Pickup From',
                                  value: 'Sector 12, Civil Lines'),
                              _SummaryRow(
                                  label: 'Deliver To',
                                  value: 'Your registered address'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
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

// ── TIMELINE STEP ─────────────────────────────────────────────────────────────

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.step,
    required this.isDone,
    required this.isActive,
    required this.isLast,
    required this.pulseAnimation,
  });

  final _StepData step;
  final bool isDone, isActive, isLast;
  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon + line
        Column(
          children: [
            AnimatedBuilder(
              animation: pulseAnimation,
              builder: (_, __) => Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  gradient: isDone
                      ? const LinearGradient(
                    colors: [Color(0xFF1D9E75), Color(0xFF0F6E56)],
                  )
                      : null,
                  color: isDone ? null : const Color(0xFF0F6E56).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                    BoxShadow(
                      color: const Color(0xFF1D9E75)
                          .withValues(alpha: pulseAnimation.value * 0.5),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ]
                      : null,
                  border: Border.all(
                    color: isDone
                        ? Colors.transparent
                        : const Color(0xFF1D9E75).withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  step.icon,
                  color: isDone
                      ? Colors.white
                      : const Color(0xFF5DCAA5).withValues(alpha: 0.3),
                  size: 18,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDone
                        ? [const Color(0xFF1D9E75), const Color(0xFF1D9E75)]
                        : [
                      const Color(0xFF1D9E75).withValues(alpha: 0.2),
                      const Color(0xFF1D9E75).withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        color: isDone
                            ? const Color(0xFF9FE1CB)
                            : const Color(0xFF5DCAA5).withValues(alpha: 0.4),
                        fontSize: 13,
                        fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    Text(
                      step.time,
                      style: TextStyle(
                        color: isDone
                            ? const Color(0xFFEF9F27)
                            : const Color(0xFF5DCAA5).withValues(alpha: 0.3),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  step.subtitle,
                  style: TextStyle(
                    color: isDone
                        ? const Color(0xFF5DCAA5).withValues(alpha: 0.7)
                        : const Color(0xFF5DCAA5).withValues(alpha: 0.3),
                    fontSize: 11,
                  ),
                ),
                if (isActive)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9E75).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF1D9E75).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      '● Current Status',
                      style: TextStyle(
                        color: Color(0xFF5DCAA5),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
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

// ── SUMMARY ROW ───────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF5DCAA5).withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF9FE1CB),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── MAP GRID PAINTER ──────────────────────────────────────────────────────────

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1D9E75).withValues(alpha: 0.08)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── DATA MODEL ────────────────────────────────────────────────────────────────

class _StepData {
  final IconData icon;
  final String title, subtitle, time;

  const _StepData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}