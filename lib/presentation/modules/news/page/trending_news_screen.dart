/// Trending news Page - Presentation Layer
/// Located in: lib/presentation/modules/News/page/trending_news_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/modules/News/widget/news_shimmer.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_card.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_empty_state.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_initial_shimmer.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';

class TrendingNewsPage extends StatelessWidget {
  const TrendingNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    // Initialize data when page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeTrendingData();
    });

    return Scaffold(
      appBar: CustomAppBar(title: "Trending"),
      body: Obx(() {
        final firstLoading =
            controller.isLoading.value && controller.newsList.isEmpty;

        // 1) Initial loading shimmer
        if (firstLoading) {
          return const NewsInitialShimmer();
        }

        // 2) Empty state with pull-to-refresh
        if (!controller.isLoading.value && controller.newsList.isEmpty) {
          return NewsEmptyState(
            onRefresh: () => controller.fetchPaginatedNews(isFirstLoad: true),
          );
        }

        // 3) News list with pagination
        return _buildNewsList(controller);
      }),
    );
  }

  Widget _buildNewsList(NewsController controller) {
    return Obx(() {
      final itemCount = controller.newsList.length +
          (controller.isMoreLoading.value ? 1 : 0);

      return RefreshIndicator(
        onRefresh: () => controller.fetchPaginatedNews(isFirstLoad: true),
        child: ListView.builder(
          controller: controller.trendingScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // News items
            if (index < controller.newsList.length) {
              final news = controller.newsList[index];
              final rel = controller.formatRelativeTime(news.publishedDate);

              return NewsCard(
                imageUrl: news.image,
                title: news.title ?? '',
                source: news.site ?? '',
                date: news.publishedDate ?? '',
                publishDate: news.publishedDate,
                tag: "just now",
                isHorizontal: true,
                showRelativeDate: false,
                relativeText: rel,
                url: news.url,
                text: news.text,
              );
            }

            // Footer shimmer
            return const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: NewsCardShimmer(),
            );
          },
        ),
      );
    });
  }
}