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

/// Helper function to safely create DecorationImage with error handling
DecorationImage? _getSafeDecorationImage(String assetPath) {
  try {
    return DecorationImage(
      image: AssetImage(assetPath),
      fit: BoxFit.fill,
      onError: (exception, stackTrace) {
        // Silently handle image loading errors
      },
      filterQuality: FilterQuality.low,
    );
  } catch (e) {
    // Return null if image cannot be loaded to prevent crashes
    return null;
  }
}

class MiniCalenderWidget extends GetView<ScheduleController> {
  const MiniCalenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return
    /// Your existing days widget
    Obx(() {
      if (controller.isLoadingCalender.value && !controller.showMore.value) {
        return SizedBox(
          height: AppSpacing.responTextHeight(100),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
            itemBuilder:
                (context, index) => ShimmerBlock(
                  width: 60,
                  height: 80,
                  radius: AppDimensions.borderRadiusLG,
                ),
            separatorBuilder: (context, index) => AppSpacing.addWidth(AppSpacing.sm),
            itemCount: 10,
          ),
        );
      }

      // Slightly increase the fixed height so inner Column + icons don't overflow
      return SizedBox(
        height: AppSpacing.responTextHeight(110),
        child: Obx(() {
          final selected = controller.selectedIndex.value;
          final days = controller.monthDays; // RxList

          return LayoutBuilder(
            builder: (context, constraints) {
              const edge = 8.0;
              const gap = 8.0;
              const visible = 5;
              final available =
                  constraints.maxWidth - (edge * 2) - (gap * (visible - 2));
              final itemWidth = available / visible;
              const tileHeight = 65.00;
              final itemExtent = itemWidth + gap;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.updateViewport(
                  viewportWidth: constraints.maxWidth,
                  itemExtent: itemExtent,
                  edge: edge,
                  gap: gap,
                  itemCount: days.length,
                );
              });
              return ListView.builder(
                controller: controller.scrollController,
                scrollDirection: Axis.horizontal,
                padding: AppSpacing.paddingSymmetric(horizontal: edge),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final item = days[index];
                  final isSelected = selected == index;
                  if (item["fullDate"] == null) {
                    return const SizedBox.shrink();
                  }
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: itemWidth,
                      child: GestureDetector(
                        onTap: () => controller.selectDay(index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                // Show image ONLY when selected
                                if (isSelected)
                                  Padding(
                                    padding: AppSpacing.paddingSymmetric(
                                      horizontal: AppSpacing.sm,
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      constraints: const BoxConstraints(
                                        minHeight: tileHeight,
                                        maxHeight: tileHeight,
                                      ),
                                      decoration: BoxDecoration(
                                        image: _getSafeDecorationImage(
                                          ImagePaths.minicalender_background,
                                        ),
                                      ),
                                    ),
                                  ),

                                // For unselected → show normal empty background
                                if (!isSelected)
                                  Padding(
                                    padding: AppSpacing.paddingSymmetric(
                                      horizontal: AppSpacing.sm,
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      constraints: const BoxConstraints(
                                        minHeight: tileHeight,
                                        maxHeight: tileHeight,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.colors.transparent,
                                      ),
                                    ),
                                  ),

                                // Text Layer
                                Positioned.fill(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          txt: item['day'] ?? '',
                                          style: TextStyle(
                                            fontSize: AppTextTheme.fontSize14,
                                            fontWeight:
                                                AppTextTheme.weightMedium,
                                            color:
                                                isSelected
                                                    ? context.colors.white
                                                    : context.colors.grey,
                                          ),
                                        ),
                                        AppSpacing.addHeight(AppSpacing.sm),
                                        AppText(
                                          txt: item["date"] ?? '',
                                          style: TextStyle(
                                            fontSize: AppTextTheme.fontSize16,
                                            fontWeight: AppTextTheme.weightBold,
                                            height: 1.0,
                                            color:
                                                isSelected
                                                    ? context.colors.white
                                                    : context.colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (controller.monthCalenderDates.isNotEmpty)
                              AppSpacing.addHeight(AppSpacing.xs),
                            if (controller.monthCalenderDates.isNotEmpty)
                              // ✅ FIXED: Always show icons section, just empty if no data
                              Obx(() {
                                if (item["fullDate"] == null) {
                                  return const SizedBox.shrink();
                                }

                                final calendarDate =
                                    item["fullDate"] as DateTime;
                                final apiData = controller.monthCalenderDates
                                    .firstWhereOrNull((d) {
                                      final apiDate = DateTimeConverter.parse(
                                        d.date,
                                        'MM-dd-yyyy',
                                      );
                                      if (apiDate == null) return false;
                                      // Compare dates by year, month, day only
                                      return DateUtils.isSameDay(
                                        apiDate,
                                        calendarDate,
                                      );
                                    });

                                if (apiData != null &&
                                    apiData.category.isNotEmpty) {
                                  // Filter out empty icon URLs and take up to 3
                                  final validIcons =
                                      apiData.category
                                          .where(
                                            (iconUrl) =>
                                                iconUrl.toString().isNotEmpty,
                                          )
                                          .take(3)
                                          .toList();

                                  if (validIcons.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  const positions = [10.0, 0.0, 20.0];

                                  return SizedBox(
                                    height: 16,
                                    width: 40,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: List.generate(
                                        validIcons.length,
                                        (i) {
                                          return Positioned(
                                            left: positions[i],
                                            child: AppImageAvatar(
                                              radius: AppDimensions.iconXS,
                                              avatarUrl: validIcons[i],
                                              fallbackAsset:
                                                  ImagePaths.dateIcon,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }

                                // Return empty if no categories
                                return const SizedBox.shrink();
                              }),
                            if (controller.monthCalenderDates.isNotEmpty)
                              AppSpacing.addHeight(AppSpacing.sm),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      );
    });
  }
}
