import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/auth/page/logout/widget/logout_dialog.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/privacy_policy/privacy_policy.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/widget/drawer_item.dart';
import 'package:wealthnxai/routes/app_routes.dart';
import 'package:wealthnxai/presentation/modules/auth/page/logout/binding/logout_binding.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: AppDimensions.drawerWidth,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.addHeight(AppSpacing.sm),
                drawerItem(
                  context,
                  iconImage: ImagePaths.proofile_icon,
                  title: 'Profile',
                  subtitle: 'Personal information',
                  onTap: () {
                    Get.toNamed(Routes.PROFILE);
                  },
                ),
                AppSpacing.addHeight(AppSpacing.sm),
                drawerItem(
                  context,
                  iconImage: ImagePaths.bank_icon,
                  title: 'Accounts',
                  subtitle: 'Manage Connected Accounts',
                  onTap: () {
                    Get.toNamed(Routes.ACCOUNT);
                  },
                ),
                AppSpacing.addHeight(AppSpacing.sm),
                drawerItem(
                  context,
                  iconImage: ImagePaths.fingerprint_icon,
                  title: 'Authentication',
                  subtitle: 'Password, biometric login',
                  onTap: () {
                    Get.toNamed(Routes.AUTHENTICATION);
                  },
                ),
                AppSpacing.addHeight(AppSpacing.sm),
                drawerItem(
                  context,
                  iconImage: ImagePaths.support_icon,
                  title: 'Support',
                  subtitle: 'Got questions for us',
                  onTap: () {
                    Get.toNamed(
                      Routes.SUPPORT,
                      arguments: {'isShowRecoverEmail': false},
                    );
                  },
                ),
                AppSpacing.addHeight(AppSpacing.sm),
                drawerItem(
                  context,
                  iconImage: ImagePaths.privacy_icon,
                  title: 'Privacy Policy',
                  subtitle: '',
                  onTap: () {
                    Get.toNamed(Routes.PRIVACY_POLICY);
                  },
                ),
                AppSpacing.addHeight(AppSpacing.md),
                drawerItem(
                  context,
                  iconImage: ImagePaths.logout_icon,
                  title: 'Log out',
                  subtitle: '',
                  onTap: () {
                    // Initialize logout dependencies via binding, then show dialog
                    LogoutBinding().dependencies();
                    Get.dialog(
                      barrierColor: context.colorScheme.surface.withOpacity(
                        0.85,
                      ),
                      const LogoutDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
