import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class AppDropdownField extends StatelessWidget {
  final String? label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
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
        DropdownButtonFormField<String>(
          hint:  AppText(txt: "Select Options"),
          value: (value == null || value!.isEmpty) ? null : value,
          validator: validator,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: AppText(txt:item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}