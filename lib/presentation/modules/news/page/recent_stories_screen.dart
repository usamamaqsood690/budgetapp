/// Recent Stories Page - Presentation Layer
/// Located in: lib/presentation/modules/News/page/recent_stories_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/modules/News/widget/news_shimmer.dart';
import 'package:wealthnxai/presentation/widgets/buttons/category_button.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_card.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_initial_shimmer.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';

class RecentStoriesPage extends StatelessWidget {
  const RecentStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    // Initialize data when page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeRecentStoriesData();
    });

    return Scaffold(
      appBar: CustomAppBar(title: "Recent Stories"),
      body: Obx(() {
        final idx = controller.selectedCategoryIndex.value;
        final initialLoading = controller.isRecentStoriesInitialLoading(idx);

        if (initialLoading) {
          return const NewsInitialShimmer(itemCount: 8);
        }

        return RefreshIndicator(
          onRefresh: () => controller.onRecentStoriesRefresh(idx),
          child: ListView(
            controller: controller.recentStoriesScrollController,
            children: [
              _buildCategoryButtons(controller, idx),
              AppSpacing.addHeight(10),
              _buildNewsList(controller, idx),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryButtons(NewsController controller, int idx) {
    return Padding(
      padding: const EdgeInsets.only(right: 40, left: 12, top: 8),
      child: Row(
        spacing: AppSpacing.spacing8,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CategoryButton(
            text: "All",
            isActive: idx == 0,
            onPressed: () => controller.selectCategory(0),
          ),
          CategoryButton(
            text: "Stocks",
            isActive: idx == 1,
            onPressed: () => controller.selectCategory(1),
          ),
          CategoryButton(
            text: "Crypto",
            isActive: idx == 2,
            onPressed: () => controller.selectCategory(2),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildNewsList(NewsController controller, int idx) {
    return Obx(() {
      final items = controller.getRecentStoriesItems(idx);
      final showLoader = controller.shouldShowRecentStoriesLoader(idx);
      final itemCount = items.length + (showLoader ? 1 : 0);

      if (items.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              'No news found',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, i) {
          if (i < items.length) {
            final news = items[i];
            final rel = controller.formatRelativeTime(news.publishedDate);

            return NewsCard(
              publishDate: news.publishedDate,
              imageUrl: news.image,
              title: news.title ?? '',
              source: news.site ?? '',
              date: news.publishedDate ?? '',
              tag: "",
              isHorizontal: true,
              showRelativeDate: false,
              relativeText: rel,
              url: news.url,
              text: news.text,
            );
          }

          // Loader row at the end
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: NewsCardShimmer(),
          );
        },
      );
    });
  }
}