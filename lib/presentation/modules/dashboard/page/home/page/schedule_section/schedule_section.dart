import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/schedule_widget/empty_schedule_card.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/schedule_widget/error_schedule_card.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/schedule_widget/schedule_shimmer_card.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/schdule_list_card/schedule_card.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.find<ScheduleController>();

    return Column(
      children: [
        SectionName(
          title: 'Schedule',
          titleOnTap: 'View All',
          onTap: () {
            Get.toNamed(Routes.SCHEDULE);
          },
        ),
        AppSpacing.addHeight(AppSpacing.md),
        Obx(() {
          if (scheduleController.isLoading.value) {
            return ScheduleShimmerCard();
          }

          if (scheduleController.errorMessage.value.isNotEmpty) {
            return ErrorScheduleCard(
              message: scheduleController.errorMessage.value,
              onRetry: scheduleController.refreshSchedule,
            );
          }

          if (scheduleController.upcomingSchedules.isEmpty) {
            return EmptyScheduleCard(
              onTap: () {
                Get.toNamed(Routes.ADD_SCHEDULE);
              },
            );
          }

          return SizedBox(
            height: AppSpacing.responTextHeight(100),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: scheduleController.upcomingSchedules.length,
              itemBuilder: (context, index) {
                final schedule = scheduleController.upcomingSchedules[index];
                return Container(
                  width: Get.size.width * 0.80,
                  margin: AppSpacing.marginOnly(right: AppSpacing.md),
                  child:  CustomBillCard(item: schedule),
                );
              },
            ),
          );
        }),
      ],
    );
  }

}
