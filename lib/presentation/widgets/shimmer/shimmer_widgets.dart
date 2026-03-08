import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';

/// Shimmer block widget for loading states
class ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? radius;

  const ShimmerBlock({
    super.key,
    required this.width,
    required this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:context.colors.shimmerBaseColor,
      highlightColor: context.colors.shimmerHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color:context.colors.shimmerColor,
          borderRadius: radius ??AppDimensions.borderRadiusXS,
        ),
      ),
    );
  }
}
