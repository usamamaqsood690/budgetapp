import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import '../controller/home_controller.dart';

class AskGenieCard extends GetView<HomeController> {
  const AskGenieCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    //  onTap: () => controller.navigateToGenie(""),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colorScheme.primary, width: 0.5),
        ),
        child: Row(
          spacing: 10,
          children: [
            Image.asset(ImagePaths.wealthgenpng, height: 21, fit: BoxFit.contain),
          //  addWidth(),
            Text(
              'Ask Wealth Genie....',
              style: TextStyle(color: context.colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}