import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class BulletPoints extends StatelessWidget {
  final List<String> bullets;
  const BulletPoints({super.key, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bullets
          .map(
            (text) => Padding(
          padding:AppSpacing.paddingOnly(bottom: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                txt:"• ",
                style: TextStyle(
                  color: context.colorScheme.surfaceContainerHigh,
                  fontSize:AppTextTheme.fontSize12 ,
                  fontWeight:AppTextTheme.weightLight,
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style:  TextStyle(
                    color: context.colorScheme.surfaceContainerHigh,
                    fontSize:AppTextTheme.fontSize12 ,
                    fontWeight:AppTextTheme.weightLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}
