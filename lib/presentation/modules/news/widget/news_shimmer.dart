/// news Shimmer Widgets - Presentation Layer
/// Located in: lib/view/news/widgets/news_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';

class NewsScreenShimmer extends StatelessWidget {
  final ScrollController scrollController;

  const NewsScreenShimmer({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final base = Colors.grey[850]!;
    final highlight = Colors.grey[700]!;

    final cardW = 280;
    //marginSide(280);
    final cardH = 240.0;
    final radius = 16.0;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 18),
      children: [
        // Trending Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SectionName(
            title: 'Trending',
            titleOnTap: 'View All',
            fontSize: 16.0,
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),

        // Trending Horizontal Shimmer
        SizedBox(
          height: cardH,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Shimmer.fromColors(
                baseColor: base,
                highlightColor: highlight,
                child: TrendingCardSkeleton(
                  width: 280,
                  //cardW,
                  height: cardH,
                  radius: radius,
                  base: base,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 45),

        // Recent Stories Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SectionName(
            title: 'Recent Stories',
            titleOnTap: 'View All',
            fontSize: 16.0,
            onTap: () {},
          ),
        ),
        const SizedBox(height: 20),

        // Category Chips Shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Shimmer.fromColors(
            baseColor: base,
            highlightColor: highlight,
            child: Row(
              children: [
                ChipSkeleton(labelWidth: 10, padH: 18, base: base),
                const SizedBox(width: 8),
                ChipSkeleton(labelWidth: 10, padH: 18, base: base),
                const SizedBox(width: 8),
                ChipSkeleton(labelWidth: 10, padH: 18, base: base),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Recent Stories List Shimmer
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Shimmer.fromColors(
              baseColor: base,
              highlightColor: highlight,
              child: RecentStoryRowSkeleton(base: base),
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== news Card Shimmer ====================

class NewsCardShimmer extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double imageSize;
  final double gap;
  final double radius;

  const NewsCardShimmer({
    super.key,
    this.padding = EdgeInsets.zero,
    this.imageSize = 80,
    this.gap = 12,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final base = Colors.grey[850]!;
    final highlight = Colors.grey[700]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: RecentStoryRowSkeleton(base: base),
      ),
    );
  }
}

// ==================== Skeleton Widgets ====================

class TrendingCardSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color base;

  const TrendingCardSkeleton({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    required this.base,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image
              Expanded(child: Container(color: base)),
              // Title lines
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LineSkeleton(
                      width: width * 0.85,
                      height: 14,
                      base: base,
                      radius: 6,
                    ),
                    const SizedBox(height: 6),
                    LineSkeleton(
                      width: width * 0.55,
                      height: 12,
                      base: base,
                      radius: 6,
                    ),
                    const SizedBox(height: 8),
                    // Meta row
                    Row(
                      children: [
                        CircleSkeleton(size: 30, base: base),
                        const SizedBox(width: 8),
                        LineSkeleton(width: 70, height: 10, base: base, radius: 4),
                        const SizedBox(width: 8),
                        LineSkeleton(width: 48, height: 10, base: base, radius: 4),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentStoryRowSkeleton extends StatelessWidget {
  final Color base;

  const RecentStoryRowSkeleton({
    super.key,
    required this.base,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: text stack
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LineSkeleton(
                width: double.infinity,
                height: 14,
                base: base,
                radius: 6,
              ),
              const SizedBox(height: 6),
              LineSkeleton(
                width: double.infinity,
                height: 12,
                base: base,
                radius: 6,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleSkeleton(size: 30, base: base),
                  const SizedBox(width: 8),
                  LineSkeleton(width: 70, height: 10, base: base, radius: 4),
                  const SizedBox(width: 8),
                  LineSkeleton(width: 60, height: 10, base: base, radius: 4),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Right: thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(width: 120, height: 110, color: base),
        ),
      ],
    );
  }
}

class ChipSkeleton extends StatelessWidget {
  final double labelWidth;
  final double padH;
  final Color base;

  const ChipSkeleton({
    super.key,
    required this.labelWidth,
    required this.padH,
    required this.base,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: 10),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(width: labelWidth, height: 10),
    );
  }
}

class LineSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final Color base;
  final double radius;

  const LineSkeleton({
    super.key,
    required this.width,
    required this.height,
    required this.base,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(width: width, height: height, color: base),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  final double size;
  final Color base;

  const CircleSkeleton({
    super.key,
    required this.size,
    required this.base,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: Container(width: size, height: size, color: base),
    );
  }
}

// ==================== Helper Function ====================

Widget trendingCardShimmer({
  required double width,
  required double height,
  required double radius,
}) {
  final base = Colors.grey[850]!;
  final highlight = Colors.grey[700]!;

  return Shimmer.fromColors(
    baseColor: base,
    highlightColor: highlight,
    child: TrendingCardSkeleton(
      width: width,
      height: height,
      radius: radius,
      base: base,
    ),
  );
}