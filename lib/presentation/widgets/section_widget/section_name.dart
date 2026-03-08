import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class SectionName extends StatelessWidget {
  SectionName({
    super.key,
    required this.title,
    this.onTap,
    this.titleOnTap,
    this.onTapColor,
    this.fontSize,
    this.textColor,
  });

  String? title;
  String? titleOnTap;
  GestureTapCallback? onTap;
  Color? onTapColor;
  Color? textColor;
  dynamic fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          txt: '$title',
          style: TextStyle(
            fontSize: fontSize ?? AppSpacing.responTextWidth(16),
            color: textColor ?? context.colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        InkWell(
          splashColor: Colors.transparent,
          onTap: onTap,
          child: AppText(
            txt: '$titleOnTap',
            style: TextStyle(
              fontSize: fontSize ?? AppSpacing.responTextWidth(14),
              color: onTapColor ?? context.colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
