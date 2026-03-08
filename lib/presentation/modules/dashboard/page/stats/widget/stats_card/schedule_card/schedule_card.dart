import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/data/models/schedule/get_upcoming_schedule_model/get_upcoming_schedule_model.dart';
import 'package:wealthnxai/presentation/modules/dashboard/controller/plaid_connection_controller.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';

class ScheduleSummeryCard extends GetView<ScheduleController> {
   ScheduleSummeryCard({super.key});

  final PlaidConnectionController _checkPlaidConnectionController =
  Get.find<PlaidConnectionController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF072B28), width: 0.5),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'This month',
                style: TextStyle(
                  color: Color(0xFF5A6570),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // SizedBox(height: 4),
              Text(
                'Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Reactive content based on loading and data state
          Obx(() {
            // Show loading indicator while fetching data
            if (controller.isLoadingExpense.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF2D9B88),
                    ),
                  ),
                ),
              );
            }

            final currentMonthTotal =
                controller.upcomingScheduleData.value?.currentMonthTotal ?? 0.0;
            final isConnected =
                _checkPlaidConnectionController.plaidResponse.value?.body.isPlaidConnected ?? false;

            // Condition 1: Has data (currentMonthTotal != 0) - show real data
            if (currentMonthTotal != 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormattedNumberText(
                    value: currentMonthTotal,
                    hint:NumberHint.price,
                    showSign: true,
                    style:  context.textTheme.bodyLarge,
                  ),
                  // Dynamic bar chart based on current month weeks
                  Builder(
                    builder: (context) {
                      final currentMonthWeeks =
                          controller
                              .upcomingScheduleData.value?.currentMonth ??
                              [];

                      if (currentMonthWeeks.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      // Find max amount to normalize bar heights
                      final double maxAmount = currentMonthWeeks.fold<double>(
                        0,
                            (prev, e) =>
                        e.totalAmount > prev ? e.totalAmount : prev,
                      );

                      // Calculate current week-of-month (1..5)
                      final now = DateTime.now();
                      final int currentWeekOfMonth = ((now.day - 1) ~/ 7) + 1;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                        currentMonthWeeks.map((weekData) {
                          final label = 'Week ${weekData.week}';
                          final isHighlighted =
                              weekData.week == currentWeekOfMonth;
                          final heightFactor =
                          maxAmount > 0
                              ? (weekData.totalAmount / maxAmount)
                              .clamp(0.0, 1.0)
                              : 0.0;

                          return _buildWeekBar(
                            label,
                            heightFactor,
                            isHighlighted,
                            null,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            }

            // Condition 2: Not connected - show dummy data
            if (isConnected == false) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dummy monthly amount'
                  FormattedNumberText(
                    value: 2500.0,
                    hint:NumberHint.price,
                    showSign: true,
                    style:  context.textTheme.bodyLarge,
                  ),
                  // Dummy bar chart based on current month weeks
                  Builder(
                    builder: (context) {
                      // Create dummy week data
                      final dummyWeeks = [
                        CurrentMonthWeek(week: 1, totalAmount: 450.0),
                        CurrentMonthWeek(week: 2, totalAmount: 680.0),
                        CurrentMonthWeek(week: 3, totalAmount: 520.0),
                        CurrentMonthWeek(week: 4, totalAmount: 850.0),
                      ];

                      // Find max amount to normalize bar heights
                      final double maxAmount = dummyWeeks.fold<double>(
                        0,
                            (prev, e) =>
                        e.totalAmount > prev ? e.totalAmount : prev,
                      );

                      // Calculate current week-of-month (1..5)
                      final now = DateTime.now();
                      final int currentWeekOfMonth = ((now.day - 1) ~/ 7) + 1;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                        dummyWeeks.map((weekData) {
                          final label = 'Week ${weekData.week}';
                          final isHighlighted =
                              weekData.week == currentWeekOfMonth;
                          final heightFactor =
                          maxAmount > 0
                              ? (weekData.totalAmount / maxAmount)
                              .clamp(0.0, 1.0)
                              : 0.0;

                          return _buildWeekBar(
                            label,
                            heightFactor,
                            isHighlighted,
                            null,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              );
            }

            // Condition 3: Connected but no data (currentMonthTotal == 0) - show empty state
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSpacing.addHeight(10),
                // Add icon in a circle with dark grey background
                Container(
                  width: 48,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF202020),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF888888),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 18),
                // Text below the icon
                const Text(
                  "You do not have any scheduled payment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeekBar(
      String label,
      double heightFactor,
      bool isHighlighted,
      double? barMaxHeight,
      ) {
    double maxBarHeight = barMaxHeight ?? 80.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: maxBarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: maxBarHeight * heightFactor,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                      isHighlighted
                          ? const Color(0xFF2D9B88)
                          : const Color(0xFF1A4A44),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isHighlighted ? Colors.white : const Color(0xFF5A6570),
                fontSize: 6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the radial pattern icon
class RadialPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    const numLines = 12;
    const angleStep = (2 * 3.14159) / numLines;

    for (int i = 0; i < numLines; i++) {
      final angle = i * angleStep;
      final path = Path();

      // Create triangular segments
      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + size.width / 2 * 0.8 * (i % 2 == 0 ? 1 : 0.6) * cos(angle),
        center.dy + size.height / 2 * 0.8 * (i % 2 == 0 ? 1 : 0.6) * sin(angle),
      );
      path.lineTo(
        center.dx +
            size.width /
                2 *
                0.8 *
                (i % 2 == 0 ? 1 : 0.6) *
                cos(angle + angleStep),
        center.dy +
            size.height /
                2 *
                0.8 *
                (i % 2 == 0 ? 1 : 0.6) *
                sin(angle + angleStep),
      );
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double cos(double angle) => angle.cos();

  double sin(double angle) => angle.sin();
}

extension MathExtension on double {
  double cos() => this * 180 / 3.14159; // Simplified for demo
  double sin() => this * 180 / 3.14159; // Simplified for demo
}
