import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/controller/plaid_connection_controller.dart';
import 'package:wealthnxai/presentation/widgets/section_widget/section_name.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import '../controller/home_controller.dart';

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    // return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionName(title: 'AI Agents', titleOnTap: '', onTap: () {}),
        AppSpacing.addHeight(8),

        SizedBox(
          height: AppSpacing.responTextHeight(110),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // ACCOUNTANT AGENT
                _buildAccountantCard(
                  context,
                  controller,
                  controller.numberFormat,
                ),

                // STOCK AGENT
                _buildStockCard(context, controller, controller.numberFormat),

                // CRYPTO AGENT
                _buildCryptoCard(context, controller, controller.numberFormat),

                // BUILD MODE
                _buildBuildModeCard(
                  context,
                  controller,
                  controller.numberFormat,
                ),
              ],
            ),
          ),
        ),
      ],
    );
    // });
  }

  // ==================== AGENT CARD BUILDERS ====================

  Widget _buildAccountantCard(
    BuildContext context,
    HomeController controller,
    NumberFormat numberFormat,
  ) {

    final plaidConnectionController = Get.find<PlaidConnectionController>();
    final isConnected = plaidConnectionController.plaidResponse.value?.body.isPlaidConnected ?? false;
    //controller.plaidController.isConnected.value;
    final networthBody = 10;
    //controller.networthController.networth.value?.body;
    final isLoading = false;
    //isConnected && networthBody == null;

    return _portfolioItem(
      context,
      isConnected: isConnected,
      isLoading: isLoading,
      agentType: "Accountant ",
      connectedTitle: 'Account Overview',
      connectedDesc: "@Accountant provide my networth summary",
      amount: 10,
      //networthBody?.totalNetWorth,
      percentage: 10,
      //networthBody?.percentageNetWorth,
      icon: ImagePaths.wg7,
      bgIcon:
          isConnected
              ? ImagePaths.notaccountant
              : "assets/images/accountant_icon.png",
      formatter: numberFormat,
    );
  }

  Widget _buildStockCard(
    BuildContext context,
    HomeController controller,
    NumberFormat numberFormat,
  ) {
    final isConnected = false;
    //controller.plaidController.isInvestment.value &&
    //controller.plaidController.isConnected.value;
    final investmentBody = 10;
    //  controller.investmentController.investmentOverview.value?.body;
    final isLoading = false;
    //isConnected && (investmentBody == null || investmentBody.isEmpty);

    return _portfolioItem(
      context,
      isConnected: isConnected,
      isLoading: isLoading,
      agentType: "Stock Agent",
      connectedTitle: 'Stock Portfolio Overview',
      connectedDesc:
          '@Stock provide me concise and comprehensive stock market overview',
      amount: 10,
      //investmentBody?.firstOrNull?.stocksTotal,
      percentage: 10,
      //investmentBody?.firstOrNull?.stocksChange24HPercent,
      icon: ImagePaths.wg3,
      bgIcon:
          isConnected ? "assets/images/stock_icon.png" : ImagePaths.notstocks,
      formatter: numberFormat,
      isPercent: true,
    );
  }

  Widget _buildCryptoCard(
    BuildContext context,
    HomeController controller,
    NumberFormat numberFormat,
  ) {
    final isConnected = false;
    //controller.plaidController.isInvestment.value &&
    //controller.plaidController.isConnected.value;
    final investmentBody = 10;
    // controller.investmentController.investmentOverview.value?.body;
    final isLoading = false;
    //isConnected && (investmentBody == null || investmentBody.isEmpty);

    return _portfolioItem(
      context,
      isConnected: isConnected,
      isLoading: isLoading,
      agentType: "Crypto Agent",
      connectedTitle: 'Crypto Portfolio Overview',
      connectedDesc:
          "@Crypto provide me concise and comprehensive crypto market overview",
      amount: 10,
      //investmentBody?.firstOrNull?.cryptoTotal,
      percentage: 10,
      //investmentBody?.firstOrNull?.cryptoChange24HPercent,
      icon: ImagePaths.wg6,
      bgIcon:
          isConnected ? "assets/images/crypto_icon.png" : ImagePaths.notcryptos,
      formatter: numberFormat,
      isPercent: true,
      isCrypto: true,
    );
  }

  Widget _buildBuildModeCard(
    BuildContext context,
    HomeController controller,
    NumberFormat numberFormat,
  ) {
    return _portfolioItem(
      context,
      isConnected: false,
      isLoading: false,
      agentType: "Build Mode",
      connectedTitle: 'Text to Visuals',
      connectedDesc: "@Build Mode visualize the dashboard of AAPL stock",
      amount: null,
      percentage: null,
      icon: ImagePaths.wg8,
      bgIcon: ImagePaths.buildMode,
      formatter: numberFormat,
      isBuildMode: true,
    );
  }

  // ==================== PORTFOLIO ITEM WIDGET ====================

  Widget _portfolioItem(
    BuildContext context, {
    required bool isConnected,
    required bool isLoading,
    required String agentType,
    required String connectedTitle,
    required String connectedDesc,
    required String icon,
    required String bgIcon,
    dynamic amount,
    dynamic percentage,
    required NumberFormat formatter,
    bool isPercent = false,
    bool isCrypto = false,
    bool isBuildMode = false,
  }) {
    // Determine Display Values
    String displayAmount = '\$0.0';
    String displayPercent = '0.00%';
    bool isNegative = false;

    if (isConnected && amount != null) {
      double val = double.tryParse(amount.toString()) ?? 0.0;
      isNegative = val < 0;
      displayAmount =
          val >= 0
              ? '\$${formatter.format(val)}'
              : '-\$${formatter.format(val.abs())}';

      double per = double.tryParse(percentage.toString()) ?? 0.0;
      displayPercent = '${per.toStringAsFixed(2)}%';
    }

    return GestureDetector(
      onTap: () {
        // Navigation to genie with query
        final controller = Get.find<HomeController>();
        // controller.navigateToGenie(isConnected ? connectedDesc : "");
      },
      child: Container(
        height: AppSpacing.responTextHeight(110),
        width: AppSpacing.responTextWidth(208),
        margin: AppSpacing.paddingOnly(right: AppSpacing.spacing12),
        padding: AppSpacing.paddingSymmetric(
          vertical: AppSpacing.spacing8,
          horizontal: AppSpacing.spacing12,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.aiagent),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header Row
            Row(
              children: [
                Image.asset(
                  icon,
                  color: Colors.white,
                  fit: BoxFit.contain,
                  width: 18,
                  height: 18,
                ),
                AppSpacing.addWidth(8),
                Flexible(
                  child: AppText(
                    txt: agentType,
                    style: TextStyle(
                      fontSize: AppSpacing.responTextWidth(14),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            AppSpacing.addHeight(8),

            // Description
            AppText(
              txt: isConnected ? connectedTitle : "$agentType Overview",
              style: TextStyle(
                fontSize: AppSpacing.responTextWidth(12),
                fontWeight: FontWeight.w300,
              ),
              maxLines: 2,
            ),
            const Spacer(),

            // Content Area - Show shimmer if loading, otherwise show data
            if (isLoading)
              _buildShimmerContent(context)
            else if (isBuildMode)
              _buildBuildModeContent(bgIcon)
            else if (isConnected)
              _buildDataContent(
                context,
                displayAmount,
                displayPercent,
                isNegative,
                isCrypto,
              )
            else
              _buildDisconnectedContent(context, bgIcon),
          ],
        ),
      ),
    );
  }

  // ==================== CONTENT BUILDERS ====================

  // Shimmer Loading Content
  Widget _buildShimmerContent(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.3),
      highlightColor: Colors.white.withOpacity(0.5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: AppSpacing.responTextHeight(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          AppSpacing.addWidth(8),
          Container(
            width: AppSpacing.responTextWidth(50),
            height: AppSpacing.responTextHeight(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          AppSpacing.addWidth(8),
          Container(
            width: AppSpacing.responTextWidth(40),
            height: AppSpacing.responTextHeight(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // Build Mode Content
  Widget _buildBuildModeContent(String bgIcon) {
    return Image.asset(
      bgIcon,
      fit: BoxFit.contain,
      height: AppSpacing.responTextHeight(40),
    );
  }

  // Data Content (Connected state with data)
  Widget _buildDataContent(
    BuildContext context,
    String displayAmount,
    String displayPercent,
    bool isNegative,
    bool isCrypto,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Amount
        Flexible(
          child: AppText(
            txt: displayAmount,
            style: TextStyle(
              fontSize: AppSpacing.responTextWidth(15),
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
          ),
        ),
        AppSpacing.addWidth(12),

        // Graph
        Expanded(
          child: SizedBox(
            height: AppSpacing.responTextHeight(20),
            child: Image.asset(
              isNegative
                  ? ImagePaths.agents_graphs3
                  : isCrypto
                  ? ImagePaths.agents_graphs4
                  : ImagePaths.agents_graphs2,
              fit: BoxFit.contain,
            ),
          ),
        ),
        AppSpacing.addWidth(12),

        // Percentage
        AppText(
          txt: displayPercent,
          style: TextStyle(
            fontSize: AppSpacing.responTextWidth(13),
            color:
                isNegative
                    ? context.colorScheme.error
                    : context.colors.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Disconnected Content (Show icon or empty state)
  Widget _buildDisconnectedContent(BuildContext context, String bgIcon) {
    return SizedBox(
      height: AppSpacing.responTextHeight(28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            bgIcon,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
          Image.asset(
            ImagePaths.agents_graphs,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }

  // ==================== LEGACY SHIMMER (Optional - for reference) ====================

  Widget coinTypeShimmer(BuildContext context) {
    return Container(
      width: AppSpacing.responTextWidth(190),
      margin: EdgeInsets.only(right: AppSpacing.responTextWidth(12)),
      padding: EdgeInsets.all(AppSpacing.responTextWidth(8)),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.greyDialog),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[600]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: AppSpacing.responTextWidth(36),
                  height: AppSpacing.responTextHeight(36),
                  decoration: BoxDecoration(
                    color: context.colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacing.addWidth(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: AppSpacing.responTextWidth(60),
                      height: AppSpacing.responTextHeight(16),
                      color: context.colors.grey,
                    ),
                    AppSpacing.addHeight(4),
                    Container(
                      width: AppSpacing.responTextWidth(40),
                      height: AppSpacing.responTextHeight(12),
                      color: context.colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            AppSpacing.addHeight(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: AppSpacing.responTextWidth(40),
                          height: AppSpacing.responTextHeight(14),
                          color: context.colors.grey,
                        ),
                        Icon(
                          Icons.arrow_drop_up,
                          color: context.colors.transparent,
                          size: AppSpacing.responTextWidth(25),
                        ),
                      ],
                    ),
                    AppSpacing.addHeight(4),
                    Container(
                      width: AppSpacing.responTextWidth(40),
                      height: AppSpacing.responTextHeight(16),
                      color: context.colors.grey,
                    ),
                  ],
                ),
                Container(
                  width: AppSpacing.responTextWidth(50),
                  height: AppSpacing.responTextHeight(20),
                  color: context.colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
