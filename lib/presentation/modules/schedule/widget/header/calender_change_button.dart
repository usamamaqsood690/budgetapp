import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

class CalenderChangeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  const CalenderChangeButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return GestureDetector(
        onTap:isDisabled ?null:onPressed,
        child: Container(
          padding: AppSpacing.paddingAll(AppSpacing.xs),
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusSM,
            border: Border.all(
              color: context.colors.grey,
              width: AppDimensions.borderWidthThin,
            ),
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconXXL,
            color: context.colorScheme.onSurface,
          ),
        )
    );
  }
}
