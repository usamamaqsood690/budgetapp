// lib/presentation/widgets/tabbar/custom_tab_bar.dart

import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabChanged;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? borderColor;
  final double borderWidth;
  final MainAxisAlignment alignment;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabChanged,
    this.fontSize = 14.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.selectedColor,       // ← now nullable, falls back to color scheme
    this.unselectedColor,     // ← now nullable, falls back to color scheme
    this.borderColor,         // ← now nullable, falls back to color scheme
    this.borderWidth = 0.4,
    this.alignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; // ← uses your ColorSchemeColors extension

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? colors.divider,
            width: borderWidth,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: alignment,
        children: tabs.map((tab) => _buildTab(tab, colors)).toList(),
      ),
    );
  }

  Widget _buildTab(String tab, ColorSchemeColors colors) {
    final isSelected = selectedTab == tab;

    return GestureDetector(
      onTap: () => onTabChanged(tab),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? (selectedColor ?? colors.white)
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          tab,
          style: TextStyle(
            color: isSelected
                ? (selectedColor ?? colors.textPrimary)
                : (unselectedColor ?? colors.textSecondary),
            fontSize: fontSize,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}