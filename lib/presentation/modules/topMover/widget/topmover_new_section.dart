import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

import '../../../widgets/avator/app_avator.dart';

class TopMoverNewsSection extends StatefulWidget {
  const TopMoverNewsSection({
    super.key,
    required this.symbol,
    this.limit = 2,
  });

  final String symbol;
  final int limit;

  @override
  State<TopMoverNewsSection> createState() => _TopMoverNewsSectionState();
}

class _TopMoverNewsSectionState extends State<TopMoverNewsSection> {
  late final NewsController _newsController;

  @override
  void initState() {
    super.initState();
    _newsController = Get.find<NewsController>();
    _newsController.fetchNewsBySymbol(
      symbol: widget.symbol,
      page: 1,
      limit: widget.limit,
    );
  }

  @override
  void dispose() {
    _newsController.clearSymbolNews();
    super.dispose();
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
       txt:    'News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: List.generate(
        widget.limit,
            (_) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          decoration: BoxDecoration(
            color: AppColorScheme.shimmerBaseColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        children: [
          Text(message, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _newsController.fetchNewsBySymbol(
              symbol: widget.symbol,
              page: 1,
              limit: widget.limit,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'No news available for this symbol.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildNewsCard({
    String? heading,
    String? title,
    String? icon,
    String? date,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                AppImageAvatar(
                  avatarUrl: icon,
                  radius: 14,
                  fallbackAsset: 'assets/icons/news_placeholder.png',
                  borderWidth: 0,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      style:  TextStyle(
                        color: context.colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      date ?? '',
                      style:  TextStyle(
                        color: context.colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_newsController.isSymbolLoading.value &&
        _newsController.symbolNewsList.isEmpty) {
      return _buildShimmer();
    }

    if (_newsController.symbolErrorMessage.isNotEmpty &&
        _newsController.symbolNewsList.isEmpty) {
      return _buildError(_newsController.symbolErrorMessage.value);
    }

    if (_newsController.symbolNewsList.isEmpty) {
      return _buildEmpty();
    }

    final items = _newsController.symbolNewsList.take(widget.limit).toList();

    return Column(
      children: items
          .map((news) => _buildNewsCard(
        heading: news.title ?? '',
        title: news.site ?? news.publisher ?? '',
        icon: news.image ?? '',
        date: _newsController.formatRelativeTime(news.publishedDate),
        onTap: () => _newsController.navigateToNewsDetail(
          news,
          tag: widget.symbol,
        ),
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        Obx(() => _buildBody()),
      ],
    );
  }
}