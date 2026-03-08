import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';
import '../controller/home_controller.dart';

class FinancialSnapshot extends StatelessWidget {
  final bool? showTitle;

  FinancialSnapshot({super.key, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    // final networth = Get.find<NetWorthController>();
    // final cashflow = Get.find<CashFlowController>();
    // final income = Get.find<IncomeController>();
    // final budget = Get.find<BudgetController>();

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AppText(
        //   txt: 'Financial Snapshot',
        //   style: TextStyle(
        //     fontSize: AppSpacing.responTextWidth(16),
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // Obx(
        //   () =>
        if (showTitle!)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                txt: 'Financial Snapshot',
                style: TextStyle(
                  fontSize: AppSpacing.responTextWidth(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              //   if (!controller.plaidController.isConnected.value)
              GestureDetector(
                //   onTap: () => Get.to(() => ConnectAccounts()),
                child: AppText(
                  txt: '+ Connect Account',
                  style: TextStyle(
                    fontSize: AppSpacing.responTextWidth(14),
                    color: const Color(0xFF2BD1C1),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        // ),
    //    Obx(() {
          // if (controller.plaidController.isLoading.value) {
          //   return Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: List.generate(4, (i) => _shimmer()),
          //   );
          // }
         // return
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _card(
                context,
                "Net Worth",
                ImagePaths.dollar,
                () => Get.toNamed("/networth"),
              ),
              _card(
                context,
                "Cash Flow",
                ImagePaths.banknote,
                () => Get.toNamed(Routes.CASHFLOW),
              ),
              _card(
                context,
                "Transactions",
                ImagePaths.profit,
                () => Get.toNamed("/transaction"),
              ),
              _card(context, "Budget", ImagePaths.assetM, () {
              //  budget.fetchBudgets();
                Get.toNamed("/budget");
              }),
            ],
        ),
       //   );
     //   }),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    String title,
    String icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        spacing: 8,
        children: [
          Container(
            width: AppSpacing.responTextWidth(50),
            height: AppSpacing.responTextHeight(50),
            padding: EdgeInsets.all(AppSpacing.responTextHeight(9)),
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Image.asset(icon, fit: BoxFit.contain),
          ),
          AppText(
            txt: title,
           textAlign: TextAlign.center,
           style: TextStyle(
             fontWeight: FontWeight.w400,
           ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Container(width: 60, height: 11, color: Colors.white),
        ),
      ],
    );
  }
}
