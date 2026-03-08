import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/topMover/crypto/widget/crypto_list_section.dart';
import 'package:wealthnxai/presentation/modules/topMover/stock/widget/stock_list_section.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class TopMover extends StatelessWidget {
  const TopMover({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionName(title: 'Top Movers', titleOnTap: '', onTap: () {}),
        const SizedBox(height: 16),
        SectionName(
          title: 'Crypto',
          titleOnTap: 'View All',
          fontSize: AppSpacing.responTextWidth(AppSpacing.spacing12),
          onTapColor: context.colors.grey,
          onTap: () => Get.toNamed(Routes.CRYPTO),
        ),
        const SizedBox(height: 16),
        CryptoListSection(),
        const SizedBox(height: 16),
        SectionName(
          title: 'Stocks',
          titleOnTap: 'View All',
          fontSize: AppSpacing.responTextWidth(AppSpacing.spacing12),
          onTapColor: context.colors.grey,
          onTap: () => Get.toNamed(Routes.STOCKS),
        ),
        const SizedBox(height: 16),
        StockListSection(),
      ],
    );
  }
}
