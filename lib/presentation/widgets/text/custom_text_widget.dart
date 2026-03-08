import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';

/// App Text Widget
/// A reusable text widget that uses the app's theme system
class AppText extends StatelessWidget {
  const AppText({
    super.key,
    this.txt,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.onTap,
    this.softWrap = false,
  });

  final String? txt;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final VoidCallback? onTap;
  final bool softWrap;
  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      txt ?? '',
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: style,
      softWrap: softWrap,
    );

    // Only wrap in InkWell if onTap is provided
    if (onTap != null) {
      return InkWell(
        highlightColor: context.colors.transparent,
        splashColor: context.colors.transparent,
        onTap: onTap,
        child: textWidget,
      );
    }

    return textWidget;
  }
}
