import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';

class ShimmerCircleBorder extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const ShimmerCircleBorder({
    super.key,
    required this.size,
    this.strokeWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:AppSpacing.paddingSymmetric(vertical: AppSpacing.xl,horizontal: AppSpacing.md),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            color: context.colorScheme.outline,
            width: AppDimensions.borderWidthThin
        ),
        borderRadius: AppDimensions.borderRadiusMD,
      ),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: context.colors.shimmerBaseColor,
            highlightColor: context.colors.shimmerHighlightColor,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: strokeWidth,
                  color: context.colors.shimmerColor,
                ),
              ),
            ),
          ),
          AppSpacing.addHeight(AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBlock(width: 120, height: 20),
              ShimmerBlock(width: 120, height: 20)
            ],)
        ],
      ),
    );
  }
}