
import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class CategoryButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.spacing12, vertical: AppSpacing.spacing4,),
        decoration: BoxDecoration(
          color:
          isActive
              ? const Color.fromRGBO(46, 173, 165, 1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color:
            isActive ? const Color.fromRGBO(46, 173, 165, 1) : Colors.grey,
            width: 0.5,
          ),
        ),
        child: AppText(
        txt:   text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}