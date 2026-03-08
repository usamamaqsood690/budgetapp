import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/switch/app_switch.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class SwitchToggleRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchToggleRow({super.key, required this.title, required this.value, required this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(
            txt: title,
            style: TextStyle(
              color: context.colorScheme.onSurface,
              fontSize:AppTextTheme.fontSize14 ,
              fontWeight:AppTextTheme.weightRegular,
            ),
          ),
        ),
        Transform.scale(
          scale: 0.7,
          child: AppSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

