
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'news_shimmer.dart';
class NewsInitialShimmer extends StatelessWidget {
  final int itemCount;

  const NewsInitialShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final base = Colors.grey[850]!;
    final highlight = Colors.grey[700]!;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: RecentStoryRowSkeleton(base: base),
        ),
      ),
    );
  }
}