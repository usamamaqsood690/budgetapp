import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/dashboard/controller/dashboard_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/budget/page/budget_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/drawer_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/home_screen.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/investment/page/investment_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/profile/page/profile_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/wallet_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/stats_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/add_expense/page/add_expense_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(() {
      final currentIndex = controller.selectedIndex.value;

      return Scaffold(
        backgroundColor: Colors.white,
        // Enable drawer gesture only on 'Stats' tab (Index 2)
        drawerEnableOpenDragGesture: currentIndex == 2,
        endDrawerEnableOpenDragGesture: currentIndex == 2,
        drawer: AppDrawer(),

        // Body
        body: _buildBody(currentIndex),

        // FAB — center-docked teal (+) button that opens Wealth Genie (index 1)
        floatingActionButton: _DashboardFab(
          onTap: () => controller.onItemTapped(1),
          isActive: currentIndex == 1,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // Bottom App Bar with notch
        bottomNavigationBar: _buildBottomNav(context, currentIndex, controller),
      );
    });
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const AddExpense();
      case 2:
        return StatsPage();
      case 3:
        return WalletPage();
      case 4:
        // return ProfilePage();
        return BudgetPage();
      // return InvestmentPage();
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
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        height: 45,
        elevation: 12,
        padding: EdgeInsets.zero,
        child: SizedBox(
          // height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home  (index 0)
              _NavItem(
                icon: Icons.home,
                isActive: currentIndex == 0,
                onTap: () => controller.onItemTapped(0),
              ),

              // Stats  (index 2)
              _NavItem(
                icon: Icons.bar_chart_rounded,
                isActive: currentIndex == 2,
                onTap: () => controller.onItemTapped(2),
              ),

              // ── Centre gap for FAB ──
              const SizedBox(width: 56),

              // Investments  (index 3)
              _NavItem(
                icon: Icons.credit_card_rounded,
                isActive: currentIndex == 3,
                onTap: () => controller.onItemTapped(3),
              ),

              // Profile  (index 4)
              _NavItem(
                icon: Icons.person_outline_rounded,
                isActive: currentIndex == 4,
                onTap: () => controller.onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FAB ──────────────────────────────────────────────────────────────────────

class _DashboardFab extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;

  const _DashboardFab({required this.onTap, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF3DAA8E),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3DAA8E).withOpacity(0.40),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          isActive ? Icons.close_rounded : Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

// ─── Nav Item ─────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Icon(
          icon,
          size: 26,
          color: isActive ? const Color(0xFF3DAA8E) : Colors.grey.shade400,
        ),
      ),
    );
  }
}
