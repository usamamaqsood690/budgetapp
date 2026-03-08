import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/core/utils/date_time_helper.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class CalendarWidget extends GetView<ScheduleController> {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoadingCalender.value;
      final monthDays = controller.monthDays;
      final selectedIndex = controller.selectedIndex.value;
      final apiDates = controller.monthCalenderDates;

      if (monthDays.isEmpty && !isLoading) {
        return Center(
          child: AppText(
            txt: 'No calendar data available',
            style: TextStyle(color: context.colors.grey),
          ),
        );
      }

      return isLoading
          ? ShimmerBlock(
            width: double.infinity,
            height: 300,
            radius: AppDimensions.borderRadiusLG,
          )
          : Column(
            children: [
              AppSpacing.addHeight(AppSpacing.sm),

              /// Weekday headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                        .map(
                          (day) =>
                              Expanded(child: Center(child: AppText(txt: day))),
                        )
                        .toList(),
              ),

              ///calender dates
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: AppSpacing.paddingAll(AppSpacing.xs),
                itemCount: monthDays.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final item = monthDays[index];
                  final date = item['fullDate'] as DateTime?;
                  if (date == null) return const SizedBox.shrink();

                  final isToday = DateUtils.isSameDay(date, DateTime.now());
                  final isSelected = selectedIndex == index;

                  // Find matching API data by comparing DateTime objects
                  final apiData = apiDates.firstWhereOrNull((d) {
                    final apiDate = DateTimeConverter.parse(
                      d.date,
                      'MM-dd-yyyy',
                    );
                    if (apiDate == null) return false;
                    // Compare dates by year, month, day only
                    return DateUtils.isSameDay(apiDate, date);
                  });

                  return GestureDetector(
                    onTap: () => controller.selectDay(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                          decoration:
                              isSelected
                                  ? BoxDecoration(
                                    borderRadius: AppDimensions.borderRadiusSM,
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        ImagePaths.calender_background,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : null,
                          child: AppText(
                            txt: "${date.day} ",
                            style: TextStyle(
                              fontSize: AppTextTheme.fontSize14,
                              fontWeight:
                                  isToday
                                      ? AppTextTheme.weightBold
                                      : AppTextTheme.weightMedium,
                              color: context.colors.white,
                            ),
                          ),
                        ),

                        // ✅ FIXED: Show icons or consistent spacer
                        if (apiData != null && apiData.category.isNotEmpty)
                          _buildDynamicIconStack(apiData.category)
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
    });
  }

  Widget _buildDynamicIconStack(List<String> categories) {
    // Filter out empty icon URLs and take up to 3
    final validIcons =
        categories.where((iconUrl) => iconUrl.isNotEmpty).take(3).toList();

    if (validIcons.isEmpty) {
      return const SizedBox.shrink();
    }

    const positions = [12.0, 5.0, 20.0];

    return SizedBox(
      height: 16,
      width: 40,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(validIcons.length, (i) {
          return Positioned(
            left: positions[i],
            child: AppImageAvatar(
              radius: 6,
              avatarUrl: validIcons[i],
              fallbackAsset: ImagePaths.dateIcon,
            ),
          );
        }),
      ),
    );
  }
}
