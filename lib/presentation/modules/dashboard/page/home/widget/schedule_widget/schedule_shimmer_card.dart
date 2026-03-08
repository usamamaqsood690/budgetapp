import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

class ScheduleShimmerCard extends StatelessWidget {
  const ScheduleShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.responTextHeight(100),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 12,
              top: 8,
              bottom: 8,
            ),
            child: Shimmer.fromColors(
              baseColor: context.colors.shimmerBaseColor,
              highlightColor: context.colors.shimmerHighlightColor,
              child: Container(
                width: AppSpacing.responTextWidth(300),
                height: AppSpacing.responTextHeight(80),
                decoration: BoxDecoration(
                  color: context.colors.shimmerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

