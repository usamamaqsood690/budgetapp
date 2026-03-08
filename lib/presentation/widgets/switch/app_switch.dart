import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final bool value ;
  final ValueChanged<bool> onChanged;
  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment.centerRight,
      scale: 0.7,
      child: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
