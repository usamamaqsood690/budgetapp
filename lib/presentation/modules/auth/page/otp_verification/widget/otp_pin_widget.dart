import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/core/utils/validators.dart';

class AppOtpField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onCompleted;
  final FormFieldValidator<String>? validator;

  const AppOtpField({
    super.key,
    required this.controller,
    this.onCompleted,
    this.validator,
  });

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      backgroundColor: AppColorScheme.transparent,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      length: 4,
      pinTheme: PinTheme(
        fieldHeight: AppSpacing.spacing64,
        fieldWidth: AppSpacing.spacing64,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(AppTextTheme.fontSize10),
        activeColor: AppColorScheme.primaryColor,
        inactiveColor: AppColorScheme.primaryColor,
        selectedColor: AppColorScheme.primaryColor,
        errorBorderColor: AppColorScheme.error,
      ),
      onChanged: (value) {
      },
      onCompleted: widget.onCompleted,
      validator: widget.validator ?? (value) => Validators.validateStrongPin(value),
    );

  }
}