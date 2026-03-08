import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';

class MonthlySummaryShimmer extends StatelessWidget {
  const MonthlySummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 40, 40, 40)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (month + year)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBlock(width: 80, height: 16),
              ShimmerBlock(width: 50, height: 14),
            ],
          ),
          AppSpacing.addHeight(21),
          // Three summary rows
          ...List.generate(3, (index) {
            return Column(
              children: [
                Container(
                  margin: AppSpacing.paddingSymmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      ShimmerBlock(
                        width: 10,
                        height: 10,
                        radius: BorderRadius.circular(2),
                      ),
                      AppSpacing.addWidth(AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBlock(width: 80, height: 14),
                            const SizedBox(height: 6),
                            ShimmerBlock(width: 140, height: 10),
                          ],
                        ),
                      ),
                      ShimmerBlock(width: 70, height: 14),
                    ],
                  ),
                ),
                AppSpacing.addHeight(AppSpacing.lg)
              ],
            );
          }),
        ],
      ),
    );
  }
}