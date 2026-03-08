import 'package:flutter/material.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';

class SummaryListSection extends StatelessWidget {
  final String title;
  final Widget listTile;
  final bool showViewAll;
  final String emptyMessage;
  final VoidCallback? onViewAll;

  const SummaryListSection({
    super.key,
    required this.title,
    required this.listTile,
    this.showViewAll = false,
    this.emptyMessage = "No data found",
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline,
          width: AppDimensions.borderWidthThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          SectionName(
            title: title,
            titleOnTap: showViewAll ? 'View All' : '',
            onTap: showViewAll ? onViewAll : null,
          ),

          const SizedBox(height: 12),

          /// Empty State
          listTile,
        ],
      ),
    );
  }
}