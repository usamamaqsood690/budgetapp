import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';

class ChartShimmer extends StatefulWidget {
  const ChartShimmer({super.key});

  @override
  State<ChartShimmer> createState() => _ChartShimmerState();
}

class _ChartShimmerState extends State<ChartShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColorScheme.shimmerBaseColor,
                AppColorScheme.shimmerColor,
                AppColorScheme.shimmerHighlightColor,
                AppColorScheme.shimmerColor,
                AppColorScheme.shimmerBaseColor,
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
              begin: Alignment(_controller.value * 4 - 2, 0),
              end: Alignment(_controller.value * 4, 0),
            ),
          ),
        );
      },
    );
  }
}