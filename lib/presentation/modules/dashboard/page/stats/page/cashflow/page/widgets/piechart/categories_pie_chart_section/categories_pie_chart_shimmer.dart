import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_circle_widget.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';

class CategoriesPieChartShimmer extends StatelessWidget {
  const CategoriesPieChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔵 Top Circle Shimmer
        ShimmerCircleBorder(size: 150),

        AppSpacing.addHeight(AppSpacing.md),

        /// 📦 Bordered Container with ListTile Shimmers
        Container(
          padding: AppSpacing.paddingSymmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colorScheme.outline,
              width: AppDimensions.borderWidthThin,
            ),
            borderRadius: AppDimensions.borderRadiusMD,
          ),
          child: Column(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    /// Left Circle
                    ShimmerBlock(
                      width: 40,
                      height: 40,
                      radius: BorderRadius.circular(20),
                    ),

                    AppSpacing.addWidth(AppSpacing.md),

                    /// Title shimmer
                    ShimmerBlock(
                      width: 150,
                      height: 16,
                      radius: BorderRadius.circular(6),
                    ),

                    AppSpacing.addWidth(AppSpacing.md),
                    Spacer(),

                    /// Trailing shimmer
                    ShimmerBlock(
                      width: 40,
                      height: 16,
                      radius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
