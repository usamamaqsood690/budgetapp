import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/budgets/controller/budget_controller.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/shimmer/shimmer_widgets.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class BudgetPage extends GetView<BudgetController> {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Budget",
      ),
      body: Column(
        children: [
          //Budget Text
          AppText(txt: "Total Budget", style: context.textTheme.headlineSmall),
          Obx(() {
            final budgetValue =
                controller.budgetBody?.totalBudget ?? 0.0;
            if (controller.isLoading.value) {
              return ShimmerBlock(width: 150, height: 30);
            }
            return FormattedNumberText(
              value: budgetValue,
              hint: NumberHint.price,
              showSign: true,
              style: context.textTheme.headlineMedium,
            );
          }),
          
        ],
      ),
    );
  }
}
