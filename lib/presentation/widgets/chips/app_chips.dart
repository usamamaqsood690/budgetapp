import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class AppChips extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AppChips({super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md,vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: isSelected ? context.colorScheme.outline : context.colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AppText(
         txt :label,
          style: TextStyle(
            color: isSelected ? context.colorScheme.onSurface: context.colorScheme.onTertiaryContainer,
            fontWeight: AppTextTheme.weightBold,
          ),
        ),
      ),
    );
  }
}
