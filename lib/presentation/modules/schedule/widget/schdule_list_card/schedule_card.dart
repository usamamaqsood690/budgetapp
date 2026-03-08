import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class CustomBillCard extends GetView<ScheduleController> {
  final RecurringItem item;

  const CustomBillCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final GlobalKey menuKey = GlobalKey();

    return Container(
      margin: AppSpacing.paddingSymmetric(vertical: AppSpacing.sm),
      padding: AppSpacing.paddingSymmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.grey,
          width: AppDimensions.borderWidthThin,
        ),
        borderRadius: AppDimensions.borderRadiusMD,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Main Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Vertical divider
              Container(
                width: AppDimensions.borderWidthExtraThick,
                height: 60,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: AppDimensions.borderRadiusSM,
                ),
              ),
              AppSpacing.addWidth(AppSpacing.sm),

              /// Avatar
              (item.logoUrl.isEmpty)
                  ? ClipOval(
                    child: Container(
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        color: CommonAppHelper.getCategoryColor(item.name),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CommonAppHelper.getCategoryIcon(item.name),
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                  : AppImageAvatar(
                    radius: AppDimensions.radiusXL,
                    avatarUrl:  item.logoUrl,
                    fallbackAsset: ImagePaths.schedule_icon,
                isCircular: true,
                  ),

              AppSpacing.addWidth(AppSpacing.sm),

              /// Title + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      txt: item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppText(
                      txt: item.description ,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.addHeight(AppSpacing.md),

              /// Price at the end
              FormattedNumberText(
                value: item.amount,
                hint:NumberHint.price,
                showSign: true,
                style:  context.textTheme.bodyLarge,
              ),
              AppSpacing.addWidth(AppSpacing.sm),
              if (item.source == ScheduleType.manual.name)
                GestureDetector(
                  key: menuKey,
                  onTap: () {
                    final RenderBox renderBox =
                        menuKey.currentContext!.findRenderObject() as RenderBox;
                    final Offset offset = renderBox.localToGlobal(Offset.zero);
                    final Size size = renderBox.size;

                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        offset.dx,
                        offset.dy + size.height,
                        offset.dx + size.width,
                        0,
                      ),
                      items: const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 10),
                              AppText(txt: "Edit"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 10),
                              AppText(txt: "Delete"),
                            ],
                          ),
                        ),
                      ],
                    ).then((value) {
                      if (value == 'edit') {
                        Get.toNamed(
                          Routes.ADD_SCHEDULE,
                          arguments: {
                            'formType': ScheduleFormType.edit,
                            'item': item,
                          },
                        );
                      } else if (value == 'delete') {
                        controller.deleteSchedule(item.id);
                      }
                    });
                  },
                  child: Icon(
                    Icons.more_vert_outlined,
                    size: AppDimensions.iconXL,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
