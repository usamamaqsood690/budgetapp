/// Category Chips Widget
/// Located in: lib/presentation/modules/News/page/widgets/category_chips.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/widgets/buttons/category_button.dart';

class CategoryChips extends StatelessWidget {
  final int selectedIndex;

  const CategoryChips({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    return Padding(
      padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.spacing12),
      child: Row(
        spacing: AppSpacing.spacing8,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CategoryButton(
            text: "All",
            isActive: selectedIndex == 0,
            onPressed: () => controller.switchCategoryWithShimmer(0),
          ),
          CategoryButton(
            text: "Stocks",
            isActive: selectedIndex == 1,
            onPressed: () => controller.switchCategoryWithShimmer(1),
          ),
          CategoryButton(
            text: "Crypto",
            isActive: selectedIndex == 2,
            onPressed: () => controller.switchCategoryWithShimmer(2),
          ),
        ],
      ),
    );
  }
}