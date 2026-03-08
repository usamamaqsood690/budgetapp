import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';

class TopMoverDetailShimmer extends StatefulWidget {
  const TopMoverDetailShimmer({super.key});

  @override
  State<TopMoverDetailShimmer> createState() => _TopMoverDetailShimmerState();
}

class _TopMoverDetailShimmerState extends State<TopMoverDetailShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopSection(),
                    const SizedBox(height: 20),
                    _box(width: double.infinity, height: 300, radius: 12),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        8,
                            (i) => _box(width: i < 6 ? 36 : 28, height: 26, radius: 5),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _box(width: 110, height: 16, radius: 4),
                    const SizedBox(height: 12),
                    ...List.generate(5, (_) => _statsRow()),
                    const SizedBox(height: 21),
                  ],
                ),
              ),
              _box(width: double.infinity, height: 80, radius: 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 21),
                    _box(width: 60, height: 16, radius: 4),
                    const SizedBox(height: 10),
                    _box(width: double.infinity, height: 13, radius: 4),
                    const SizedBox(height: 6),
                    _box(width: double.infinity, height: 13, radius: 4),
                    const SizedBox(height: 6),
                    _box(width: double.infinity, height: 13, radius: 4),
                    const SizedBox(height: 6),
                    _box(width: 220, height: 13, radius: 4),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(width: 130, height: 30, radius: 6),
            const SizedBox(height: 8),
            _box(width: 80, height: 16, radius: 4),
          ],
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_statItem(), const SizedBox(height: 8), _statItem()],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_statItem(), const SizedBox(height: 8), _statItem()],
            ),
          ],
        ),
      ],
    );
  }

  Widget _statItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(width: 50, height: 11, radius: 3),
        const SizedBox(height: 4),
        _box(width: 70, height: 13, radius: 3),
      ],
    );
  }

  Widget _statsRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_sectionOptionShimmer(), _sectionOptionShimmer()],
      ),
    );
  }

  Widget _sectionOptionShimmer() {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(width: 70, height: 11, radius: 3),
          const SizedBox(height: 5),
          _box(width: 100, height: 14, radius: 3),
        ],
      ),
    );
  }

  Widget _box({
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColorScheme.shimmerBaseColor,
            AppColorScheme.shimmerHighlightColor,
            AppColorScheme.shimmerBaseColor,
          ],
          stops: const [0.0, 0.5, 1.0],
          transform: _SlidingGradientTransform(_animation.value),
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);
  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}