import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';
class NewsEmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final String title;

  const NewsEmptyState({
    super.key,
    required this.onRefresh,
    this.title = 'No News Available',
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Empty(
              title: title,
              height: AppSpacing.responTextHeight(70),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}