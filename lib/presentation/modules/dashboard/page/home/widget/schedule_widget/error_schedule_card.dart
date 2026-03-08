import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class ErrorScheduleCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorScheduleCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRetry,
      borderRadius: AppDimensions.borderRadiusMD,
      child: Container(
        width: double.infinity,
        padding: AppSpacing.paddingSymmetric(
          horizontal: AppSpacing.spacing16,
          vertical: AppSpacing.spacing16,
        ),
        decoration: BoxDecoration(
          borderRadius: AppDimensions.borderRadiusMD,
          color: context.colors.surfaceElevated,
          border: Border.all(
            color: context.colors.error,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: context.colors.error,
              size: AppDimensions.iconLG,
            ),
            AppSpacing.addWidth(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    txt: 'Unable to load schedule',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.addHeight(AppSpacing.xs),
                  AppText(
                    txt: message.isNotEmpty
                        ? '$message • Tap to retry'
                        : 'Something went wrong • Tap to retry',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

