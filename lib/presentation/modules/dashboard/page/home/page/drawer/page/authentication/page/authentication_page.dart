import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/controller/authentication_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/widget/switch_toggle_row.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/widget/option_tile.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationPageController());

    return Scaffold(
      appBar: CustomAppBar(title: 'Authentication'),
      body: Padding(
        padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            OptionTile(
              title: 'Change Password'.tr,
              onTap: () {
                Get.toNamed(
                  Routes.CHANGEPASSWORD,
                  arguments: {
                    'passwordChangeType': PasswordChangeType.changePassword,
                  },
                );
              },
            ),
            OptionTile(
              title: 'Email & Password Authentication'.tr,
              onTap: () {
                Get.toNamed(Routes.EMAIL_PASSWORD_AUTH);
              },
            ),
            Obx(
              () =>SwitchToggleRow(
                  title: 'Face ID / Fingerprint',
                  value: controller.faceIdEnabled.value,
                onChanged: controller.toggleFaceId,)

            ),
          ],
        ),
      ),
    );
  }
}
