import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/presentation/modules/dashboard/controller/dashboard_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/drawer_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/home_screen.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/investment/page/investment_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/stats_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wealth_genie/page/wealth_genie_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(() {
      final currentIndex = controller.selectedIndex.value;

      return Scaffold(
        // Enable drawer gesture only on 'Stats' tab (Index 2)
        drawerEnableOpenDragGesture: currentIndex == 2,
        endDrawerEnableOpenDragGesture: currentIndex == 2,
        drawer: AppDrawer(),

        // Body: build only the current tab page
        body: _buildBody(currentIndex),

        // Bottom Navigation Bar
        bottomNavigationBar: _buildBottomNav(context, currentIndex, controller),
      );
    });
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const WealthGeniePage();
      case 2:
        return  StatsPage();
      case 3:
        return  InvestmentPage();
      default:
        return const HomePage();
    }
  }

  Widget _buildBottomNav(
    BuildContext context,
    int currentIndex,
    DashboardController controller,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.colors.background, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: controller.onItemTapped,
          type: BottomNavigationBarType.fixed,
          // backgroundColor: context.gc(AppColor.bottomNav),
          // selectedItemColor: context.gc(AppColor.white),
          // unselectedItemColor: context.gc(AppColor.grey),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          items: [
            _navItem(
              context,
              currentIndex == 0 ? ImagePaths.homeicon : ImagePaths.unfillhome,
              'Home',
              0,
              currentIndex,
            ),
            _navItem(
              context,
              ImagePaths.wealth,
              'Wealth Genie',
              1,
              currentIndex,
            ),
            _navItem(context, ImagePaths.vitalsicon, 'Stats', 2, currentIndex),
            _navItem(
              context,
              currentIndex == 3
                  ? ImagePaths.fillinvest
                  : ImagePaths.investmenticon,
              'Investments',
              3,
              currentIndex,
              // Don't apply color tint for investments icon
              applyColor: currentIndex != 3,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
    BuildContext context,
    String path,
    String label,
    int index,
    int currentIndex, {
    bool applyColor = true,
  }) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        path,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        // color:
        //     applyColor
        //         ? (index == currentIndex
        //             ? context.gc(AppColor.white)
        //             : context.gc(AppColor.grey))
        //         : null,
      ),
      label: label,
    );
  }
}
