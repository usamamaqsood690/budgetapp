import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

class AppDialog extends StatelessWidget {
  final Widget? child;
  const AppDialog({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.lg) ,
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusSM),
      child: Container(
        padding:AppSpacing.paddingAll(AppSpacing.md),
        decoration: BoxDecoration(
          color:context.colorScheme.surface,
          borderRadius:AppDimensions.borderRadiusXL,
          boxShadow: [
            BoxShadow(
              color: const Color(0x14FFFFFF),
              blurRadius: 6.73,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: const Color(0x33787878),
              blurRadius: 31.61,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child
      ),
    );
  }
}
