import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/controller/stats_controller.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
class NetWorthSummaryCard extends GetView<StatsController> {
  const NetWorthSummaryCard({super.key});

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
          // Header
          const Text(
            'This month',
            style: TextStyle(
              color: Color(0xFF5A6570),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            'Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Image.asset(ImagePaths.verticalLine, height: 100),
              AppSpacing.addWidth(10),

              ///Image vertical bar
              Expanded(
                child: Obx(() {
                  try {
                    final assetsLogos =
                    (controller.statsModel.value?.body.networth.cashAccounts ?? const [])
                        .map((e) => e)
                        .whereType<String>()
                        .where((url) => url.trim().isNotEmpty)
                        .toList();

                    final liabilitiesLogos =
                    (controller.statsModel.value?.body.networth.creditAccounts ??
                        const [])
                        .map((e) => e)
                        .whereType<String>()
                        .where((url) => url.trim().isNotEmpty)
                        .toList();

                    // Safely get totalAssets with exception handling
                    final totalAssets =
                        controller.statsModel.value?.body.networth.cash ?? 0.0;

                    // Safely get totalLiabilities with exception handling
                    final totalLiabilities =
                        controller.statsModel.value?.body.networth.credit ?? 0.0;

                    return Column(
                      children: [
                        // Cash item
                        _buildSummaryItem(
                          label: 'Cash',
                          amount: totalAssets,
                          icon: assetsLogos,
                          context: context
                        ),
                        const SizedBox(height: 10),

                        // Divider
                        Image.asset(ImagePaths.horizontalLine),
                        const SizedBox(height: 10),

                        // Credit Card item
                        _buildSummaryItem(
                          label: 'Credit Card',
                          amount: totalLiabilities,
                          icon: liabilitiesLogos,
                            context: context
                        ),
                      ],
                    );
                  } catch (e) {
                    // Handle any exceptions gracefully
                    return Column(
                      children: [
                        _buildSummaryItem(
                          label: 'Cash',
                          amount: 0.0,
                          icon: [],
                            context: context
                        ),
                        const SizedBox(height: 10),
                        Image.asset(ImagePaths.horizontalLine),
                        const SizedBox(height: 10),
                        _buildSummaryItem(
                          label: 'Credit Card',
                          amount: 0.0,
                          icon: [],
                            context: context
                        ),
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required double amount,
    required List<String> icon,
    required BuildContext context
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF7A8590),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child:
                FormattedNumberText(
                  value: amount,
                  showSign: true,
                  style: context.textTheme.bodyLarge,
                )
              ),
            ],
          ),
        ),
        _buildOverlappedLogos(icon),
      ],
    );
  }

  Widget _buildOverlappedLogos(List<String> logos) {
    final display = logos.take(3).toList();
    if (display.isEmpty) return const SizedBox.shrink();

    const double size = 15;
    const double overlap = 2; // bigger = more overlap

    return SizedBox(
      width: size + ((display.length - 1) * (size - overlap)),
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < display.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF072B28), width: 1),
                ),
                child: ClipOval(
                  child: Image.network(
                    display[i],
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                        Container(color: const Color(0xFF1B2A2A)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
