import 'package:flutter/material.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/schdule_list_card/schedule_card.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

Widget buildGroupedExpenses(
    BuildContext context,
    List<RecurringItem> expenses,
    ) {
  // Group expenses by category
  final Map<String, List<RecurringItem>> groupedExpenses = {};
  for (var expense in expenses) {
    if (!groupedExpenses.containsKey(expense.category)) {
      groupedExpenses[expense.category] = [];
    }
    groupedExpenses[expense.category]!.add(expense);
  }

  return Column(
    children:
    groupedExpenses.entries.map((entry) {
      final category = entry.key;
      final categoryList = entry.value;
      final totalAmount = categoryList.fold<double>(
        0,
            (sum, item) => sum + item.amount,
      );

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header with total amount
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    txt:CommonAppHelper.getCategoryLabel(category),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  AppText(
                    txt:"\$${totalAmount.toInt()}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // List of expenses under this category
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                // Safe index check
                if (index < 0 || index >= categoryList.length) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 2,
                  ),
                  child: CustomBillCard(item: categoryList[index]),
                );
              },
            ),
          ],
        ),
      );
    }).toList(),
  );
}

