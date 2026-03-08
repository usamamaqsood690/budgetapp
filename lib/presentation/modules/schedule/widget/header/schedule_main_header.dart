import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/core/utils/date_time_helper.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/header/calender_change_button.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/calender/calender_widget.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/calender/mini_calender_widget.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/month_year_picker/month_year_picker_dialog.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class ScheduleMainHeader extends GetView<ScheduleController> {
  const ScheduleMainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          /// Month + Year with arrows
          Padding(
            padding: AppSpacing.paddingSymmetric(
              vertical: AppSpacing.sm,
              horizontal: AppSpacing.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Left Arrow
                CalenderChangeButton(
                  icon: Icons.keyboard_arrow_left_outlined,
                  onPressed:
                      controller.isSwitchingMonth.value
                          ? null
                          : () => controller.changeMonth(-1),
                ),

                /// Month & Year
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                        barrierColor: context.colorScheme.surface.withOpacity(0.85),
                        MonthYearPickerDialog(controller: controller));
                  },
                  child: Obx(() {
                    return controller.isSwitchingMonth.value
                        ? Column(
                          children: [
                            // Approx sizes matching your texts
                            ShimmerBlock(width: 110, height: 22),
                            AppSpacing.addHeight(AppSpacing.sm),
                            ShimmerBlock(width: 60, height: 16),
                          ],
                        )
                        : Column(
                          children: [
                            AppText(
                              txt: DateTimeConverter.monthName(
                                controller.currentDate.value,
                              ),
                            ),
                            AppText(
                              txt: DateTimeConverter.toCustom(
                                controller.currentDate.value,
                                'yyyy',
                              ),
                            ),
                          ],
                        );
                  }),
                ),

                /// Right Arrow
                CalenderChangeButton(
                  icon: Icons.keyboard_arrow_right_outlined,
                  onPressed:
                      controller.isSwitchingMonth.value
                          ? null
                          : () => controller.changeMonth(1),
                ),
              ],
            ),
          ),

          /// Calendar Part (reactive on showMore toggle)
          Obx(() {
            return controller.showMore.value
                ? const CalendarWidget()
                : const MiniCalenderWidget();
          }),

          ///Show more and less part
          Obx(() {
            return GestureDetector(
              onTap: () {
                controller.changeCalender();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    txt: controller.showMore.value ? "Show Less" : "Show More",
                    style: TextStyle(
                      fontSize: AppTextTheme.fontSize12,
                      fontWeight: AppTextTheme.weightMedium,
                      color: context.colors.grey,
                    ),
                  ),
                  Icon(
                    controller.showMore.value
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    size: AppDimensions.iconXXL,
                    color: context.colors.grey,
                  ),
                ],
              ),
            );
          }),
          AppSpacing.addHeight(AppSpacing.sm),
        ],
      ),
    );
  }
}
