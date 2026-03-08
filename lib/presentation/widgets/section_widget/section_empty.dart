import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class SectionEmpty extends StatelessWidget {
  SectionEmpty({super.key, this.title});

  String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.spacing64,
      alignment: Alignment.center,
      // padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            txt: '$title',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          AppSpacing.addHeight(AppSpacing.spacing10),
        ],
      ),
    );
  }
}
