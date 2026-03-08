import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class AppDivider extends StatefulWidget {
  final String? text;

  const AppDivider({super.key, this.text});

  @override
  State<AppDivider> createState() => _AppDividerState();
}

class _AppDividerState extends State<AppDivider> {
  @override
  Widget build(BuildContext context) {
    // Shared divider style
    Widget line = Expanded(
      child: Divider(
        color: context.colorScheme.outline,
        thickness:  AppDimensions.borderWidthThin,
      ),
    );

    // If no text, return a simple horizontal line
    if (widget.text == null || widget.text!.isEmpty) {
      return Divider(
        color:  context.colorScheme.outline,
        thickness: AppDimensions.borderWidthThin,
      );
    }

    // Otherwise, return the Row with the text
    return Row(
      children: [
        line,
        Padding(
          padding:AppSpacing.paddingSymmetric(horizontal: AppSpacing.md) ,
          child: AppText(
            txt: widget.text!.tr,
          ),
        ),
        line,
      ],
    );
  }
}