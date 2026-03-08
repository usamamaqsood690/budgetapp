import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/auth/page/recover_account/binding/recover_account_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/recover_account/widget/recover_account_dialog.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class DeleteProfileSection extends StatelessWidget {
  const DeleteProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RecoverAccountBinding(accountType: AccountType.delete).dependencies();
        Get.dialog(RecoverAccountDialog());
      },
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.delete_outline_outlined,
                size: AppDimensions.iconXXL,
                color: context.colorScheme.error,
              ),
              AppSpacing.addWidth(AppSpacing.sm),
              AppText(
                txt: "Delete Account",
                style: TextStyle(color: context.colorScheme.error),
              ),
            ],
          ),
          AppSpacing.addHeight(AppSpacing.xxxl),
        ],
      ),
    );
  }
}
