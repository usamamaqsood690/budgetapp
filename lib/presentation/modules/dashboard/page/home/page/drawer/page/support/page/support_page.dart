import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/modules/auth/page/recover_account/binding/recover_account_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/recover_account/widget/recover_account_dialog.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/controller/support_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/page/discard_link/discord_link_community.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/page/frequent_qna/frequent_qna.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/page/live_support_chat/live_support_chat.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/widget/email_sender.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/widget/option_tile.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class SupportPage extends GetView<SupportPageController> {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Support"),
      body: Padding(
        padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: AppText(txt: "What can we help you with?".tr)),
            AppSpacing.addHeight(AppSpacing.sm),

            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Live Customer Support Typically reply within ",
                  style: TextStyle(
                    color: context.colors.grey,
                    fontSize: AppTextTheme.fontSize12,
                    fontWeight: AppTextTheme.weightRegular,
                  ),
                  children: [
                    TextSpan(
                      text: "360 minutes",
                      style: TextStyle(
                        color: context.colorScheme.onPrimaryFixed,
                        fontSize: AppTextTheme.fontSize12,
                        fontWeight: AppTextTheme.weightMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.addHeight(AppSpacing.xxl),

            OptionTile(
              title: "Live Customer Support".tr,
              onTap: () {
                Get.to(const LiveSupportChatPage());
              },
            ),
            OptionTile(
              title: "Answers users frequently asked questions".tr,
              onTap: () {
                Get.to(const QNAWebViewScreen());
              },
            ),
            OptionTile(
              title: "Ask Through Community".tr,
              onTap: () {
                Get.toNamed(Routes.COMMUNITY);
              },
            ),
            OptionTile(
              showDivider: true,
              title: "Contact Through Email".tr,
              onTap: () async {
                await EmailSender.openSupportEmail(context);
              },
            ),
            Obx(() {
              if (!controller.isShowRecoverEmail.value) {
                return const SizedBox.shrink();
              }
              return OptionTile(
                showDivider: false,
                title: "Recover Account".tr,
                onTap: () {
                  RecoverAccountBinding(
                    accountType: AccountType.recover,
                  ).dependencies();
                  Get.dialog(RecoverAccountDialog());
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
