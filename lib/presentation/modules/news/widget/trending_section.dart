/// Trending Section Widget
/// Located in: lib/presentation/modules/News/page/widgets/trending_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/modules/news/widget/news_card.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();
    final double cardHeight = 270.0;
    final double cardWidth = MediaQuery.of(context).size.width * 0.75;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SectionName(
            title: 'Trending',
            titleOnTap: 'View All',
            onTap: () => Get.toNamed(Routes.TRENDING_NEWS)
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: Obx(() {
            final trending = controller.trending6;

            if (trending.isEmpty) {
              return Center(
                child: Empty(
                  title: 'News',
                  height: AppSpacing.responTextHeight(70),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: trending.length,
              itemBuilder: (context, index) {
                final news = trending[index];
                return NewsCard(
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

                );
              },
            );
          }),
        ),
      ],
    );
  }
}