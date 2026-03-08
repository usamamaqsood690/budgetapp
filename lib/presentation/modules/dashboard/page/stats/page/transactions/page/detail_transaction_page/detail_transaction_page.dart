import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/app_common_helper.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/detail_transaction_page/controller/detail_transaction_controller.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/Formatted_number_text.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class DetailTransactionPage extends StatelessWidget {
  const DetailTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailTransactionController>();

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Transactions Details'),
        body: Padding(
          padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md * 2),
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: AppSpacing.paddingSymmetric(vertical: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppSpacing.addHeight(50),
                  Image.asset(ImagePaths.tickNew, width: 150),
                  AppSpacing.addHeight(36),
                  AppText(
                    txt: 'Transaction Successfully',
                    style: const TextStyle(
                      color: Color(0xff959595),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FormattedNumberText(
                    value: controller.amount,
                    hint: NumberHint.price,
                    fontSize: 48,
                    fontWeight:  FontWeight.w800,
                  ),
                  AppSpacing.addHeight(60),
                  Column(
                    children: [
                      _buildTransactionDetail(
                        heading: 'Description',
                        title: controller.description?.isNotEmpty == true
                            ? controller.description!
                            : '-',
                      ),
                      AppSpacing.addHeight(16),
                      const Divider(
                        height: 0.25,
                        color: Colors.grey,
                        thickness: 0,
                      ),
                      AppSpacing.addHeight(16),
                      _buildTransactionDetail(
                        heading: 'Category',
                        title: CommonAppHelper.formatCategoryName(
                          controller.category ?? '',
                        ),
                      ),
                      AppSpacing.addHeight(16),
                      const Divider(
                        height: 0.25,
                        color: Colors.grey,
                        thickness: 0,
                      ),
                      AppSpacing.addHeight(16),
                      _buildTransactionDetail(
                        heading: 'Transfer Date',
                        title:
                            controller.date != null
                                ? DateFormat('MM - dd - yyyy').format(
                                  DateTime.parse(controller.date!).toLocal(),
                                )
                                : '-',
                      ),
                      AppSpacing.addHeight(16),
                      const Divider(
                        height: 0.25,
                        color: Colors.grey,
                        thickness: 0,
                      ),
                      AppSpacing.addHeight(16),
                      _buildTransactionDetail(
                        heading: 'Transfer Time',
                        title:
                            controller.date != null
                                ? DateFormat('hh:mm a').format(
                                  DateTime.parse(controller.date!).toLocal(),
                                )
                                : '-',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: AppButton(onTap: controller.onDonePressed, txt: 'Done'),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionDetail({
    required String heading,
    required String title,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          txt: '$heading: ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: AppText(
            txt: title,
            maxLines: 3,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
