import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class FilterItemTile extends StatelessWidget {
  const FilterItemTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.paddingOnly(bottom: AppSpacing.md,),
        child: Row(
          children: [
            SizedBox(width: 20, height: 20, child: Image.asset(icon)),
            AppSpacing.addWidth(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                      txt: title,
                      style: context.textTheme.bodyLarge
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    txt: subtitle,
                    style: TextStyle(color: context.colors.grey, fontSize: AppTextTheme.fontSize14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,size: 24),
          ],
        ),
      ),
    );
  }
}