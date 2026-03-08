/// Fintech Insider Section Widget - For Home Screen
/// Located in: lib/presentation/modules/news/page/news_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_card.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';


class NewsSection extends StatelessWidget {
  NewsSection({super.key});

  final controller = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionName(
          title: 'News',
          titleOnTap: 'View All',
          onTap: () {
            controller.fetchPaginatedNews(isFirstLoad: true);
            Get.toNamed(Routes.NEWS);
          },
        ),
        AppSpacing.addHeight(AppSpacing.spacing12),
        Obx(() {
          // Show shimmer when loading and list is empty
          if (controller.isLoading.value && controller.newsList.isEmpty) {
            return _buildShimmer(context);
          }

          // Show empty state
          if (controller.newsList.isEmpty) {
            return Center(
              child: Empty(title: 'news', height: AppSpacing.responTextHeight(70)),
            );
          }

          // Show news list
          return _buildNewsList(context);
        }),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    // Use fixed double values instead of helper functions
    final double cardWidth = MediaQuery.of(context).size.width * 0.75;
    final double cardHeight = 210.0;

    final base = Colors.grey[850]!;
    final highlight = Colors.grey[700]!;

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Shimmer.fromColors(
            baseColor: base,
            highlightColor: highlight,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsList(BuildContext context) {
    // Use fixed double values
    final double cardHeight = 270.0;
    final double cardWidth = MediaQuery.of(context).size.width * 0.75;

    return SizedBox(
      height: cardHeight,
      child: Builder(
        builder: (context) {
          final trending = controller.trending6;

          if (trending.isEmpty) {
            return Center(
              child: Empty(title: 'News', height: AppSpacing.responTextHeight(70)),
            );
          }

          final itemCount = trending.length >= 2 ? 2 : trending.length;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final news = trending[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: cardWidth,
                  child: NewsCard(
                    imageUrl: news.image,
                    title: news.title ?? '',
                    source: news.site ?? '',
                    date: news.publishedDate ?? '',
                    publishDate: news.publishedDate,
                    tag: "Just Now",
                    isHorizontal: false,
                    showRelativeDate: false,
                    relativeText: '',
                    url: news.url,
                    text: news.text,
                    width: cardWidth,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

