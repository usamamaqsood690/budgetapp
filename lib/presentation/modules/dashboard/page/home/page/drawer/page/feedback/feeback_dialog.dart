import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/controller/home_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/feedback/controller/feedback_controller.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/dialogs/app_dialog.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';

class FeedbackScreenDialog extends StatelessWidget {
  const FeedbackScreenDialog({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackController());
    final homeController = Get.find<HomeController>();
    final user = homeController.currentUser.value;
    final displayName = user?.name ?? '';
    return AppDialog(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onPressed ?? () => Get.back(),
                child: Icon(Icons.close),
              ),
            ),
            Row(
              children: [
                AppText(txt: "Hi  $displayName  ".tr),
                AppSpacing.addHeight(AppSpacing.sm),
                Text('👋', style: TextStyle(fontSize: AppTextTheme.fontSize14)),
              ],
            ),
            AppSpacing.addHeight(AppSpacing.sm),
            AppText(txt: "We'd love your feedback!".tr),
            AppSpacing.addHeight(AppSpacing.lg),
            Obx(
              () => Column(
                children:
                    controller.feedbackOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String option = entry.value;
                      bool isSelected = controller.selectedOption.value == index;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => controller.toggleOption(index),
                            child: Container(
                              margin: AppSpacing.marginAll(AppSpacing.sm),
                              child: Row(
                                children: [
                                  // Circular checkbox
                                  Container(
                                    width: AppDimensions.iconXL ,
                                    height: AppDimensions.iconXL ,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? context.colors.white
                                                : context.colors.grey,
                                        width:AppDimensions.borderWidthThin,
                                      ),
                                      color:
                                          isSelected
                                              ? context.colors.white
                                              : Colors.transparent,
                                    ),
                                    child:
                                        isSelected
                                            ? Icon(
                                              Icons.check,
                                              size: AppDimensions.iconMD,
                                              color: context.colors.black,
                                            )
                                            : null,
                                  ),
                                  AppSpacing.addWidth(AppSpacing.md),
                                  Expanded(child: AppText(txt: option.tr)),
                                ],
                              ),
                            ),
                          ),
                          controller.selectedOption.value == index &&
                                  option == "Other"
                              ? Column(
                                children: [
                                  AppTextField(
                                    controller: controller.descriptionController,
                                    label: "".tr,
                                    keyboardType: TextInputType.text,
                                    hintText: 'e.g I like the clean design',
                                    textInputAction: TextInputAction.done,
                                    maxLines: 3,
                                  ),
                                  AppSpacing.addHeight(AppSpacing.sm),
                                ],
                              )
                              : AppSpacing.addHeight(AppSpacing.z),
                        ],
                      );
                    }).toList(),
              ),
            ),
            AppButton(
              onTap: () async {
                await controller.submitFeedback();
              },
              txt: 'Submit Feedback',
            ),
          ],
        ),
      ),
    );
  }
}
