import 'package:flutter/material.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class EmptyScheduleCard extends StatelessWidget {
  final VoidCallback? onTap;

  const EmptyScheduleCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.borderRadiusMD,
      child: Container(
        width: double.infinity,
        height: AppDimensions.buttonHeightLG,
        padding: AppSpacing.paddingSymmetric(
          horizontal: AppSpacing.spacing16,
          vertical: AppSpacing.spacing16,
        ),
        decoration: BoxDecoration(
          borderRadius: AppDimensions.borderRadiusMD,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.colors.primaryDark, context.colors.black],
            stops: const [0.1, 0.9],
          ),
          border: Border.all(
            color: context.colorScheme.outline,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  // Calendar Icon Container
                  Image.asset(
                    ImagePaths.schedule,
                    fit: BoxFit.contain,
                    color: context.colors.onPrimary,
                  ),
                  AppSpacing.addWidth(AppSpacing.md),
                  // Text
                  AppText(
                    txt: 'Add Schedule',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: context.colors.onPrimary,
              size: AppDimensions.iconXL,
            ),
          ],
        ),
      ),
    );
  }
}
