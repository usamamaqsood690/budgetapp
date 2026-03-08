import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/controller/stats_controller.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/formatted_number_text.dart';

class NetWorthSection extends GetView<StatsController> {
  const NetWorthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Net Worth",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message:
              "Net worth is a measure of financial health, calculated by subtracting total liabilities from total assets.",
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.grey,
                size: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Obx(() {
              final netWorth =
                  controller.statsModel.value?.body.networth.totalNetWorth ?? 0;

              return controller.isVisible.value?  FormattedNumberText(
               value: netWorth,
                style: const TextStyle(
                  fontSize: 22.75,
                  fontWeight: FontWeight.w500,
                ),
              ) : SizedBox( width:65,height:30,child: Text("*****",style: const TextStyle(
                fontSize: 22.75,
                fontWeight: FontWeight.w500,
              ),));
            }),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: controller.toggleVisibility,
              child: Obx(
                    () => Image.asset(
                  controller.isVisible.value
                      ? ImagePaths.visible
                      : ImagePaths.invisible,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),


      ],
    );
  }
}