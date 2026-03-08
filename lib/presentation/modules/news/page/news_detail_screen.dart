/// News Detail Screen - Presentation Layer
/// Located in: lib/presentation/modules/News/page/news_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/domain/entities/news_entity/news_entity.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/modules/news/widget/trending_section.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key});

  static const int _maxLines = 10;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    return Obx(() {
      final news = controller.selectedNews.value;

      // Show empty state if no news selected
      if (news == null) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: const CustomAppBar(title: 'News'),
          body: const Center(
            child: Text(
              'No news selected',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        );
      }

      return Scaffold(
        // backgroundColor: Colors.black,
        appBar: CustomAppBar(title: news.title ?? ''),
        body: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontal(AppSpacing.spacing12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(news),
              AppSpacing.addHeight(15),
              _buildSourceInfo(controller, news),
              AppSpacing.addHeight(20),
              _buildTitle(news),
              AppSpacing.addHeight(10),
              if (news.text != null && news.text!.isNotEmpty)
                _buildDescription(context, controller, news),
              AppSpacing.addHeight(30),
              const TrendingSection(),
              AppSpacing.addHeight(20),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildImageSection(NewsEntity news) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.WEB_VIEW,
          arguments: {'url': news.url ?? '', 'title': news.title ?? ''},
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 190,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (news.image != null && news.image!.isNotEmpty)
                    ? CachedNetworkImage(
                  imageUrl: news.image!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade800,
                    highlightColor: Colors.grey.shade600,
                    child: Container(color: Colors.grey.shade800),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/Card.png',
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(
                  'assets/images/Card.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                constraints: const BoxConstraints(minWidth: 55),
                height: 19,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16.1),
                  border: Border.all(
                    color: Colors.grey.shade500,
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    news.site ?? '',
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceInfo(NewsController controller, NewsEntity news) {
    final tag = controller.selectedNewsTag.value;
    final relativeTime = controller.selectedNewsRelativeTime.value;

    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://www.google.com/s2/favicons?sz=64&domain_url=${news.site ?? ''}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade700,
                highlightColor: Colors.grey.shade500,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/expensewallet.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.site ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    controller.formatDateWithRelative(
                      news.publishedDate,
                      relativeTime,
                    ),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  if (tag.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(NewsEntity news) {
    return Text(
      news.title ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDescription(
      BuildContext context,
      NewsController controller,
      NewsEntity news,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: news.text!,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            height: 1.6,
          ),
        );

        final tp = TextPainter(
          text: span,
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        final bool isOverflowing = tp.didExceedMaxLines;

        return Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                textAlign: TextAlign.justify,
                txt: news.text!,
                maxLines: controller.isDescriptionExpanded.value ? null : _maxLines,
                overflow: controller.isDescriptionExpanded.value
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              if (isOverflowing) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: controller.toggleDescriptionExpanded,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white54,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        controller.isDescriptionExpanded.value
                            ? "See Less"
                            : "See More",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}