import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/profile/controller/user_profile_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/widget/option_tile.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/dialogs/app_dialog.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class ProfileAvatar extends GetView<UserProfileController> {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      builder: (controller) {
        final File? pickedFile = controller.profileImageFile.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // If user has picked a new image in this session, show it.
            if (pickedFile != null)
              CircleAvatar(
                radius: AppDimensions.radiusXXXL,
                backgroundImage: FileImage(pickedFile),
              )
            else
              Obx(()=>AppImageAvatar(
                radius: AppDimensions.radiusXXXL,
                fallbackAsset: ImagePaths.person,
                avatarUrl: controller.profilePic.value,
              ),),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Get.dialog(
                      barrierColor: context.colorScheme.surface.withOpacity(0.85),
                      _showImageSourceDialog(context));
                },
                child: Container(
                  padding: AppSpacing.paddingAll(AppSpacing.sm),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: AppDimensions.iconXXL,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _showImageSourceDialog(BuildContext context) {
    return AppDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(txt: 'Change profile picture'),
          AppSpacing.addHeight(AppSpacing.md),
          OptionTile(
            title: 'Pick from gallery',
            onTap: () {
              controller.pickProfileImageFromGallery();
            },
            showDivider: true,
            icon: Icons.photo_library,
          ),
          AppSpacing.addHeight(AppSpacing.md),
          OptionTile(
            title: 'Take a photo',
            onTap: () {
              controller.pickProfileImageFromCamera();
            },
            showDivider: true,
            icon: Icons.camera_alt,
          ),
        ],
      ),
    );
  }
}
