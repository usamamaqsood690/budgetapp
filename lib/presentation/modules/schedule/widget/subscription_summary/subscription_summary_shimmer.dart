import 'package:flutter/material.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';

Widget subscriptionSummaryShimmer() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(child: _summaryItemSkeleton()),
      summaryDividerAsset(),
      Expanded(child: _summaryItemSkeleton()),
      summaryDividerAsset(),
      Expanded(child: _summaryItemSkeleton()),
    ],
  );
}


Widget _summaryItemSkeleton() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // value bar
      ShimmerBlock(
        width: 90,
        height: 14,
      ),
      const SizedBox(height: 6),
      // label bar
      ShimmerBlock(
        width: 120,
        height: 10,
      ),
    ],
  );
}

Widget summaryDividerAsset() {
  // your existing divider image
  return Padding(
    padding:AppSpacing.paddingSymmetric(horizontal: AppSpacing.sm),
    child: Image.asset(
      ImagePaths.dividerLine,
    ),
  );
}