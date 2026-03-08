import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/core/utils/date_time_helper.dart';
import 'package:wealthnxai/data/models/stats/transactions/get_transaction_response_model/get_transaction_response_model.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/controller/transaction_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/detail_transaction_page/binding/detail_transaction_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/detail_transaction_page/detail_transaction_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/transaction_filter_page/transaction_filter_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/widget/shimmer/transaction_shimmer_widget.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/widget/transection_tile/transaction_tile.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/spacer/app_empty_widget.dart';
import 'package:wealthnxai/presentation/widgets/state_manager/app_state_builder.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';

class TransactionsPage extends GetView<TransactionsController> {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Transactions',
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => TransactionFilterScreen());
            },
            child: Icon(Icons.filter_alt_outlined),
          ),
          AppSpacing.addWidth(AppSpacing.sm),
        ],
      ),
      body: Padding(
        padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.sm),
        child: Column(
          children: [
            // Search bar
            AppTextField(
              controller: controller.searchController,
              onChanged: (value) => controller.filterTransactions(),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: AppTextTheme.fontSize12,
                    color: context.colors.grey),
                prefixIcon: IconButton(
                  icon: Icon(Icons.search, color: context.colors.grey),
                  onPressed: () {},
                ),
              ),
            ),
            AppSpacing.addHeight(AppSpacing.md),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTran.value && controller.filteredTransactions.isEmpty) {
                  return TransactionShimmerWidget();
                } else if (controller.errorMessage.isNotEmpty && controller.filteredTransactions.isEmpty) {
                  return ErrorStateWidget(
                    message: controller.errorMessage.value,
                    title: 'Failed to load transactions',
                    onRetry: () => controller.fetchTransations(force: true),
                  );
                } else if (controller.filteredTransactions.isEmpty) {
                  return Empty(title: 'No transactions found', width: 140);
                } else {
                  Widget listView;
                  
                  if (controller.isAmountSortActive.value) {
                    listView = ListView.builder(
                      itemCount: controller.filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final txn = controller.filteredTransactions[index];

                        return Column(
                          children: [
                            TransactionTile(
                                onTap: () {
                                  Get.to(
                                    () => const DetailTransactionPage(),
                                    binding: DetailTransactionBinding(),
                                    arguments: {
                                      'amount': txn.amount,
                                      'date': DateTimeConverter.toISODate(txn.date!),
                                      'category': txn.category,
                                      'description': txn.title
                                    },
                                  );
                                },
                                title: "${txn.title}",
                                date: DateTimeConverter.toISOShortDate(txn.date!),
                                leading: AppImageAvatar(
                                  fallbackAsset: ImagePaths.bank_icon,
                                  avatarUrl: txn.logoUrl,
                                  isCircular: true,
                                  radius: 20,
                                ),
                                amount: txn.amount ?? 0.0),
                            const AppDivider(),
                          ],
                        );
                      },
                    );
                  } else {
                    final groupedTransactions = controller.groupedTransactions;

                    listView = ListView.builder(
                      itemCount: groupedTransactions.length,
                      itemBuilder: (context, groupIndex) {
                        String dateLabel = groupedTransactions.keys.elementAt(
                          groupIndex,
                        );
                        List<TransBody> dateTransactions =
                            groupedTransactions[dateLabel]!;
                        bool isLastGroup =
                            groupIndex == groupedTransactions.length - 1;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date header
                            Padding(
                              padding: AppSpacing.paddingSymmetric(
                                  vertical: AppSpacing.sm),
                              child: AppText(
                                txt: dateLabel,
                                style: TextStyle(
                                  color: context.colors.grey,
                                  fontSize: AppTextTheme.fontSize14,
                                  fontWeight: AppTextTheme.weightBold,
                                ),
                              ),
                            ),

                            // Transactions under this date
                            ...dateTransactions.asMap().entries.map((entry) {
                              int txnIndex = entry.key;
                              TransBody txn = entry.value;
                              bool isLastInGroup =
                                  txnIndex == dateTransactions.length - 1;

                              return Column(
                                children: [
                                  TransactionTile(
                                    onTap: () {
                                      Get.to(
                                        () => const DetailTransactionPage(),
                                        binding: DetailTransactionBinding(),
                                        arguments: {
                                          'amount': txn.amount,
                                          'date': DateTimeConverter.toISODate(txn.date!),
                                          'category': txn.category,
                                          'description': txn.title
                                        },
                                      );
                                    },
                                    title: "${txn.title}",
                                    date: DateTimeConverter.toISOShortDate(txn.date!),
                                    leading: AppImageAvatar(
                                      fallbackAsset: ImagePaths.bank_icon,
                                      avatarUrl: txn.logoUrl,
                                      isCircular: true,
                                      radius: 20,
                                    ),
                                    amount: txn.amount ?? 0.0),
                                  // Show divider unless it's the last transaction in the last group
                                  if (!(isLastInGroup && isLastGroup))
                                    const AppDivider(),
                                ],
                              );
                            }),
                          ],
                        );
                      },
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.fetchTransations(force: true),
                    child: listView,
                  );
                }
              }),
            ),
            // addHeight(40),
          ],
        ),
      ),
    );
  }
}