import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
class AppRadioButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const AppRadioButton({
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Radio<bool>(
      value: true,
      groupValue: selected,
      activeColor: context.colors.white,
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.grey.shade400;
      }),
      onChanged: (_) => onTap(),
    );
  }
}