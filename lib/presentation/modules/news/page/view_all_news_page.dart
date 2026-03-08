/// View All news Page - Presentation Layer
/// Located in: lib/presentation/modules/News/page/view_all_news_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/modules/News/widget/news_shimmer.dart';
import 'package:wealthnxai/presentation/modules/news/widget/category_chips.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_list.dart';
import 'package:wealthnxai/presentation/modules/news/widget/recent_stories_header.dart';
import 'package:wealthnxai/presentation/modules/news/widget/trending_section.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

class ViewAllNewsPage extends StatelessWidget {
  const ViewAllNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    return Scaffold(
      appBar: CustomAppBar(title: 'News'),
      body: Padding(
        padding: AppSpacing.paddingAll(AppSpacing.spacing12),
        child: Obx(() {
          final idx = controller.selectedCategoryIndex.value;
          final initialLoading = controller.isInitialLoading(idx);

          if (initialLoading) {
            return NewsScreenShimmer(
              scrollController: controller.viewAllScrollController,
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.onRefresh(idx),
            child: ListView(
              controller: controller.viewAllScrollController,
              children: [
                // ========== Trending Section ==========
                const TrendingSection(),

                // ========== Recent Stories Section ==========
                const RecentStoriesHeader(),
                AppSpacing.addHeight(10),

                // ========== Category Chips ==========
                CategoryChips(selectedIndex: idx),
                AppSpacing.addHeight(10),

                // ========== News List ==========
                const NewsList(),
              ],
            ),
          );
        }),
      ),
    );
  }
}