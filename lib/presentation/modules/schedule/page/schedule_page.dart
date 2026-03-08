import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/schdule_list_card/schedule_list_section.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/header/schedule_main_header.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/app_bar/schedule_app_bar.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/subscription_summary/subscription_summary.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// Initial Load (runs once when widget builds first time)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.currentDate.value = DateTime.now();
      controller.rebuildFor(controller.currentDate.value);
      controller.fetchMonthCalender(controller.currentDate.value);
      controller.fetchScheduleByDateTime(controller.currentDate.value);
    });

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            /// App Bar
            const SliverScheduleAppBar(),

            /// Main Header
            const ScheduleMainHeader(),

            /// Subscription Summary + Title
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: AppSpacing.paddingSymmetric(
                        horizontal: AppSpacing.sm),
                    child: const SubscriptionSummary(),
                  ),

                  AppSpacing.addHeight(AppSpacing.lg),

                  Padding(
                    padding: AppSpacing.paddingSymmetric(
                        horizontal: AppSpacing.sm),
                    child: AppText(
                      txt: "Today Schedule".tr,
                      style: TextStyle(
                        fontSize: AppTextTheme.fontSize18,
                        fontWeight: AppTextTheme.weightBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Schedule Cards List Section
            const ScheduleListSection(),
          ],
        ),
      ),
    );
  }
}
