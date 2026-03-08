import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool showDivider;
  final IconData icon;

  const OptionTile({
    super.key,
    required this.title,
    required this.onTap,
    this.showDivider = true,
    this.icon = Icons.arrow_forward_ios,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius:AppDimensions.borderRadiusMD,
          onTap: onTap,
          child: Padding(
            padding:AppSpacing.paddingSymmetric(vertical: AppSpacing.z),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(txt: title,),
                 Icon(icon,size: AppDimensions.iconXXL,),
              ],
            ),
          ),
        ),
        if (showDivider) ...[const AppDivider(),  AppSpacing.addHeight(AppSpacing.md),],
      ],
    );
  }
}
