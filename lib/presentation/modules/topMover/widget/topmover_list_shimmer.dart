import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';

class TopMoverListShimmer extends StatelessWidget {
  final int itemCount;

  const TopMoverListShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorScheme.shimmerBaseColor,
      highlightColor: AppColorScheme.shimmerHighlightColor,
      child: Column(
        children: List.generate(
          itemCount,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 70,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColorScheme.shimmerColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColorScheme.shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColorScheme.shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColorScheme.shimmerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}