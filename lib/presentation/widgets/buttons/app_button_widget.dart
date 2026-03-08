import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// App Button Widget
/// A flexible button widget that supports text, icons, and custom styling
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onTap,
    required this.txt,
    this.addWidget,
    this.style,
  });

  final VoidCallback onTap;
  final String txt;
  final Widget? addWidget;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onTap,
      style: style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (addWidget != null) ...[
            addWidget!,
           AppSpacing.addWidth(AppSpacing.sm) ,
          ],
          AppText(txt: txt,),
        ],
      ),

    );
  }
}
