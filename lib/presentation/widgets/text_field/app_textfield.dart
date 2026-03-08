import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

/// Generic text field used across the app for consistent styling.
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final InputDecoration? decoration;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.suffixIcon,
    this.decoration,
    this.maxLines,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          AppText(txt: label!),
          AppSpacing.addHeight(AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: context.colors.white),
          validator: validator,
          onChanged: onChanged,
          textInputAction: textInputAction,
          maxLines: maxLines ?? 1,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          decoration:
              decoration ??
              InputDecoration(
                hintText: hintText,
                suffixIcon: suffixIcon,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: context.colors.onSurface,
                    width: AppDimensions.borderWidthThin,
                  ),
                  borderRadius: AppDimensions.borderRadiusMD,
                ),
              ),
        ),
      ],
    );
  }
}
