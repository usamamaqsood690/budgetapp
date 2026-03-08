import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/controller/home_controller.dart';

class HomeHeader extends StatelessWidget {

   HomeHeader({super.key});
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => controller.openDrawer(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 6.0),
            child: Image.asset(
              ImagePaths.menu,
              fit: BoxFit.contain,
              height: AppSpacing.responTextHeight(14),
            ),
          ),
        ),
        GestureDetector(
        //  onTap: () => Get.to(() => NotificationScreen()),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 6.0),
            child: Image.asset(
              ImagePaths.noti,
              fit: BoxFit.contain,
              height: AppSpacing.responTextHeight(20),
            ),
          ),
        ),
      ],
    );
  }
}