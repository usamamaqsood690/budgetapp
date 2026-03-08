import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';

class TransactionShimmerWidget extends StatelessWidget {
  const TransactionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            height: 70,
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                /// Circle Avatar Shimmer
                const ShimmerBlock(
                  width: 32,
                  height: 32,
                  radius: BorderRadius.all(Radius.circular(30)),
                ),

                AppSpacing.addWidth(AppSpacing.sm),

                /// Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ShimmerBlock(
                        width: 150,
                        height: 16,
                      ),
                      SizedBox(height: 8),
                      ShimmerBlock(
                        width: 100,
                        height: 12,
                      ),
                    ],
                  ),
                ),

                /// Amount shimmer
                const ShimmerBlock(
                  width: 60,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}