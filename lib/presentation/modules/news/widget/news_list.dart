/// News List Widget
/// Located in: lib/presentation/modules/News/page/widgets/news_list.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_card.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';

import 'news_initial_shimmer.dart';
import 'news_shimmer.dart';


class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    return Obx(() {
      final tab = controller.selectedCategoryIndex.value;
      final showListShimmer = controller.isTabLoading.value;

      if (showListShimmer) {
        return  NewsInitialShimmer();
      }

      final items = controller.getItemsForCurrentTab();

      if (items.isEmpty) {
        return Padding(
          padding: AppSpacing.paddingAll(AppSpacing.spacing24),
          child: Center(
            child: Empty(
              title: 'News',
              height: AppSpacing.responTextHeight(70),
            ),
          ),
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final news = items[index];
          final showRel = tab == 1 || tab == 2 || tab == 0;
          final relText = showRel
              ? controller.formatRelativeTime(news.publishedDate)
              : '';

          return NewsCard(
            publishDate: news.publishedDate,
            imageUrl: news.image,
            title: news.title ?? '',
            source: news.site ?? '',
            date: news.publishedDate ?? '',
            tag: "",
            isHorizontal: true,
            showRelativeDate: showRel,
            relativeText: relText,
            url: news.url,
            text: news.text,
          );
        },
      );
    });
  }


}