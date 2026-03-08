// /// Home Screen - Presentation Layer
// /// Main home page displayed after successful login
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wealthnxai/core/themes/app_color.dart';
// import 'package:wealthnxai/core/themes/app_spacing.dart';
// import 'package:wealthnxai/core/themes/app_text_theme.dart';
// import 'package:wealthnxai/presentation/modules/home/controller/home_controller.dart';
// import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
// import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
// import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final HomeController controller = Get.find<HomeController>();
//
//     return Scaffold(
//       backgroundColor: context.gc(AppColor.background),
//       appBar: AppBar(
//         backgroundColor: context.gc(AppColor.background),
//         elevation: 0,
//         title: AppText(
//           txt: 'Home',
//           style: context.headlineMedium?.copyWith(
//             color: context.gc(AppColor.textPrimary),
//             fontWeight: AppTextTheme.weightBold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout, color: context.gc(AppColor.textPrimary)),
//             onPressed: controller.logout,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value &&
//             controller.currentUser.value == null) {
//           return const Center(child: AppLoadingWidget());
//         }
//
//         final user = controller.currentUser.value;
//
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(AppSpacing.md),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Welcome Section
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(AppSpacing.lg),
//                 decoration: BoxDecoration(
//                   color: context.gc(AppColor.primary).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: context.gc(AppColor.primary).withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText(
//                       txt: 'Welcome back!',
//                       style: context.headlineSmall?.copyWith(
//                         color: context.gc(AppColor.textPrimary),
//                         fontWeight: AppTextTheme.weightBold,
//                       ),
//                     ),
//                     SizedBox(height: AppSpacing.sm),
//                     if (user != null) ...[
//                       AppText(
//                         txt: user.name,
//                         style: context.titleLarge?.copyWith(
//                           color: context.gc(AppColor.primary),
//                           fontWeight: AppTextTheme.weightSemiBold,
//                         ),
//                       ),
//                       SizedBox(height: AppSpacing.xs),
//                       AppText(
//                         txt: user.email,
//                         style: context.bodyMedium?.copyWith(
//                           color: context.gc(AppColor.textSecondary),
//                         ),
//                       ),
//                     ] else
//                       AppText(
//                         txt: 'User',
//                         style: context.titleLarge?.copyWith(
//                           color: context.gc(AppColor.primary),
//                           fontWeight: AppTextTheme.weightSemiBold,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: AppSpacing.xl),
//
//               // User Info Section
//               if (user != null) ...[
//                 AppText(
//                   txt: 'Account Information',
//                   style: context.titleMedium?.copyWith(
//                     color: context.gc(AppColor.textPrimary),
//                     fontWeight: AppTextTheme.weightSemiBold,
//                   ),
//                 ),
//                 SizedBox(height: AppSpacing.md),
//                 _buildInfoCard(
//                   context,
//                   icon: Icons.person,
//                   label: 'Name',
//                   value: user.name,
//                 ),
//                 SizedBox(height: AppSpacing.sm),
//                 _buildInfoCard(
//                   context,
//                   icon: Icons.email,
//                   label: 'Email',
//                   value: user.email,
//                 ),
//                 if (user.phone != null) ...[
//                   SizedBox(height: AppSpacing.sm),
//                   _buildInfoCard(
//                     context,
//                     icon: Icons.phone,
//                     label: 'Phone',
//                     value: user.phone!,
//                   ),
//                 ],
//                 SizedBox(height: AppSpacing.xl),
//               ],
//
//               // Actions Section
//               AppText(
//                 txt: 'Quick Actions',
//                 style: context.titleMedium?.copyWith(
//                   color: context.gc(AppColor.textPrimary),
//                   fontWeight: AppTextTheme.weightSemiBold,
//                 ),
//               ),
//               SizedBox(height: AppSpacing.md),
//               AppButton(
//                 onTap: controller.refreshUserData,
//                 txt: 'Refresh Data',
//                 borderColor: context.gc(AppColor.primary),
//                 txtColor: context.gc(AppColor.white),
//                 backgroundColor: context.gc(AppColor.primary),
//               ),
//               SizedBox(height: AppSpacing.sm),
//               AppButton(
//                 onTap: controller.logout,
//                 txt: 'Logout',
//                 borderColor: context.gc(AppColor.error),
//                 txtColor: context.gc(AppColor.error),
//                 backgroundColor: context.gc(AppColor.transparent),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildInfoCard(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(AppSpacing.md),
//       decoration: BoxDecoration(
//         color: context.gc(AppColor.surface),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: context.gc(AppColor.divider), width: 1),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: context.gc(AppColor.primary), size: 24),
//           SizedBox(width: AppSpacing.md),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   txt: label,
//                   style: context.bodySmall?.copyWith(
//                     color: context.gc(AppColor.textSecondary),
//                   ),
//                 ),
//                 SizedBox(height: AppSpacing.xs),
//                 AppText(
//                   txt: value,
//                   style: context.bodyMedium?.copyWith(
//                     color: context.gc(AppColor.textPrimary),
//                     fontWeight: AppTextTheme.weightMedium,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/schedule_section/schedule_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/discord_card.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/portfolio_section.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/top_mover.dart';
import 'package:wealthnxai/presentation/modules/news/page/news_section.dart';
import '../widget/ask_genie_card.dart';
import '../widget/financial_snapshot.dart';
import '../widget/home_greeting.dart';
import '../widget/home_header.dart';

// Note: You can add 'today_movers_section.dart' and 'home_community_card.dart' similarly

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: AppSpacing.responTextHeight(50)),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePaths.grad),
          fit: BoxFit.contain,
          alignment: Alignment.topLeft,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              // 1. Header
              HomeHeader(),
              AppSpacing.addHeight(21),

              // 2. Greeting
              const HomeGreeting(),
              AppSpacing.addHeight(12),

              // 3. Ask Genie
              const AskGenieCard(),
              AppSpacing.addHeight(30),

              // 4. Portfolio (Agents)
              const PortfolioSection(),
              AppSpacing.addHeight(30),

              // 5. Financial Snapshot
               FinancialSnapshot(),
              AppSpacing.addHeight(30),

              // 6. Top Mover
              const TopMover(),
              AppSpacing.addHeight(30),

              // 7. Schedule
              const ScheduleSection(),
              AppSpacing.addHeight(30),

              const DiscordCard(),
              AppSpacing.addHeight(30),

              // 8. News
              NewsSection(),
              //   const NewsSection(),
              AppSpacing.addHeight(30),
            ],
          ),
        ),
      ),
    );
  }
}