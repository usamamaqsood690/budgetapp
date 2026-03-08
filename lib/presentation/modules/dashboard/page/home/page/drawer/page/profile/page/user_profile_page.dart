import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/profile/controller/user_profile_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/profile/widget/delete_profile_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/profile/widget/profile_avator.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_dropdown_textfield.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';

/// User Profile Page
class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          SizedBox(
            width: AppSpacing.responTextWidth(100),
            child: AppButton(
              txt: "Save",
              onTap: controller.updateUserProfile,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingSymmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar + name
            Center(child: ProfileAvatar()),
            AppSpacing.addHeight(AppSpacing.sm),
            Obx(() {
              final name = controller.displayNameText.isNotEmpty
                  ? controller.displayNameText
                  : '${controller.firstNameController.text} ${controller.lastNameController.text}'
                      .trim();
              return AppText(
                txt: name,
                textAlign: TextAlign.center,
              );
            }),
            // Details section
            AppTextField(
              controller: controller.firstNameController,
              label: "First Name".tr,
              keyboardType: TextInputType.name,
              hintText: 'John',
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            AppTextField(
              controller: controller.lastNameController,
              label: "Last Name".tr,
              keyboardType: TextInputType.name,
              hintText: 'Doe',
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            AppTextField(
              controller: controller.emailController,
              label: "Email".tr,
              keyboardType: TextInputType.emailAddress,
              hintText: 'john@gmail.com',
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            AppTextField(
              controller: controller.dobController,
              label: "Date of Birth".tr,
              keyboardType: TextInputType.none,
              hintText: 'MM/DD/YY',
              readOnly: true,
              onTap: () => controller.selectDateOfBirth(context),
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            GetBuilder<UserProfileController>(
              builder: (_) => AppDropdownField(
                label: "Gender".tr,
                value: controller.gender,
                items: const ['Male', 'Female'],
                onChanged: controller.setGender,
              ),
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            GetBuilder<UserProfileController>(
              builder: (_) => AppDropdownField(
                label: "Marital Status",
                value: controller.maritalStatus,
                items: const ['Single', 'Married'],
                onChanged: controller.setMaritalStatus,
              ),
            ),
            AppSpacing.addHeight(AppSpacing.md),
            DeleteProfileSection(),
          ],
        ),
      ),
    );
  }
}
