import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/routes/app_routes.dart';


class RecentStoriesHeader extends StatelessWidget {
  const RecentStoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontal(10),
      child: SectionName(
        title: 'Recent Stories',
        titleOnTap: 'View All',
        onTap: () =>  Get.toNamed(Routes.RECENT_STORIES),
            //Get.to(() => const RecentStoriesPage()),
      ),
    );
  }
}