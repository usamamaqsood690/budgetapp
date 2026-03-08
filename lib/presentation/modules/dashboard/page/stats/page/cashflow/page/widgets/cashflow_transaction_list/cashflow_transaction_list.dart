import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/data/models/stats/cashflow/get_cashflow_response_model/get_cashflow_response_model.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/detail_transaction_page/detail_transaction_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/detail_transaction_page/binding/detail_transaction_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/transection_tile/transaction_tile.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';

class CategoryTransactionListPage extends StatelessWidget {
  const CategoryTransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final TransactionCategory? category =
    args['transaction'] as TransactionCategory?;

    final transactions = category?.categoryTransactions ?? [];

    if (category == null || transactions.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: CommonAppHelper.formatCategoryName(category?.name ??''),
        ),
        body: Center(
          child: Empty(
            title: 'No transactions found for this category',
            width: 120,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: CommonAppHelper.formatCategoryName(category.name),
      ),
      body: Padding(
        padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
        child: ListView.separated(
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const AppDivider(),
          itemBuilder: (context, index) {
            return TransactionTile(
              title: transactions[index].title,
              date: transactions[index].date,
              amount: transactions[index].amount,
              leading: AppImageAvatar(
                fallbackAsset: ImagePaths.bank_icon,
                avatarUrl: transactions[index].logoUrl,
                isCircular: true,
                backgroundColor: context.colorScheme.onPrimary,
                radius: 15,
              ),
              onTap: () =>
              {
                Get.to(
                      () => const DetailTransactionPage(),
                  binding: DetailTransactionBinding(),
                  arguments: {
                    'amount': transactions[index].amount,
                    'date': transactions[index].date,
                    'category': transactions[index].category,
                    'description': transactions[index].description
                  },
                )
              });
          },
        ),
      ),
    );
  }
}