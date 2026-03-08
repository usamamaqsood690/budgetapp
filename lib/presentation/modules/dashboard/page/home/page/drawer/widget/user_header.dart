import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/controller/home_controller.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

Widget buildUserHeader(BuildContext context) {
  final homeController = Get.find<HomeController>();
  return Row(
    children: [

     Obx(()=>AppImageAvatar(
       radius: AppDimensions.iconXXL,
       fallbackAsset: ImagePaths.person,
       avatarUrl: homeController.currentUser.value?.avatar,
     )),

      AppSpacing.addWidth(AppSpacing.lg),

      Obx(()=>AppText(txt: homeController.currentUser.value?.name ?? ''),)
    ],
  );
}