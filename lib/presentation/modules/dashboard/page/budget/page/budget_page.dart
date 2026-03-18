import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/budget/page/add_budget/binding/add_budget_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/budget/page/add_budget/page/add_budget_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/budget/page/category_budget/binding/category_budget_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/budget/page/category_budget/page/category_budget_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/budget/page/recent_expense/binding/recent_expense_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/budget/page/recent_expense/page/recent_expense_page.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int _selectedPeriod = 1; // 0=Week, 1=Month, 2=Year
  final List<String> _periods = ['Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // 1. Teal Header
            // _BudgetingHeader(),
            CustomAppbar(title: 'Budget'),

            // 2. Scrollable body
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Container(
                  padding: AppSpacing.paddingSymmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppSpacing.addHeight(20),
                        // 3. Budget summary card (stays in teal zone)
                        _BudgetSummaryCard(
                          selectedPeriod: _selectedPeriod,
                          periods: _periods,
                          onPeriodChanged:
                              (i) => setState(() => _selectedPeriod = i),
                        ),

                        Column(
                          children: [
                            AppSpacing.addHeight(24),

                            // 4. Overall progress
                            const _OverallBudgetProgress(),
                            AppSpacing.addHeight(24),

                            // 5. Category budgets
                            const _CategoryBudgetSection(),
                            AppSpacing.addHeight(24),

                            // 6. Recent expenses
                            const _RecentExpensesSection(),
                            AppSpacing.addHeight(24),

                            // 7. Add Budget button
                            _AddBudgetButton(),
                            AppSpacing.addHeight(24),
                            AppSpacing.addHeight(24),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _BudgetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            padding: AppSpacing.paddingSymmetric(
              horizontal: AppSpacing.md,
              // vertical: AppSpacing.lg,
            ),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(400, 50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.addHeight(64),

                // Greeting row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    Text(
                      'Budget',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.to(
                        //   () => NotificationPage(),
                        //   binding: NotificationBinding(),
                        // );
                      },
                      child: _NotificationBell(),
                    ),
                  ],
                ),
                AppSpacing.addHeight(24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Budget Summary Card ──────────────────────────────────────────────────────

class _BudgetSummaryCard extends StatelessWidget {
  final int selectedPeriod;
  final List<String> periods;
  final ValueChanged<int> onPeriodChanged;

  const _BudgetSummaryCard({
    required this.selectedPeriod,
    required this.periods,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Period selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(periods.length, (i) {
            final isActive = i == selectedPeriod;
            return GestureDetector(
              onTap: () => onPeriodChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isActive ? Color(0xFF3DAA8E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  periods[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? Colors.white : const Color(0xFF888888),
                  ),
                ),
              ),
            );
          }),
        ),
        AppSpacing.addHeight(20),

        // Spent vs Budget
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Spent',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E).withOpacity(0.80),
                    fontSize: 12,
                  ),
                ),
                AppSpacing.addHeight(4),
                const Text(
                  '\$ 1,284.00',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total Budget',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E).withOpacity(0.80),
                    fontSize: 12,
                  ),
                ),
                AppSpacing.addHeight(4),
                const Text(
                  '\$ 2,500.00',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        AppSpacing.addHeight(16),

        // Progress bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 1284 / 2500,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF3DAA8E),
                ),
              ),
            ),
            AppSpacing.addHeight(6),
            Text(
              '\$1,216.00 remaining',
              style: TextStyle(
                color: Color(0xFF1A1A2E).withOpacity(0.85),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Overall Budget Progress ──────────────────────────────────────────────────

class _OverallBudgetProgress extends StatelessWidget {
  const _OverallBudgetProgress();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular progress
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: 1284 / 2500,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF3DAA8E),
                    ),
                  ),
                ),
                const Text(
                  '51%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget Used',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                AppSpacing.addHeight(10),
                _ProgressLegendRow(
                  color: const Color(0xFF3DAA8E),
                  label: 'Spent',
                  value: '\$1,284',
                ),
                AppSpacing.addHeight(6),
                _ProgressLegendRow(
                  color: Colors.grey.shade300,
                  label: 'Remaining',
                  value: '\$1,216',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressLegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _ProgressLegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

// ─── Category Budget Section ──────────────────────────────────────────────────

class _CategoryBudgetSection extends StatelessWidget {
  const _CategoryBudgetSection();

  static const List<_CategoryBudget> _categories = [
    _CategoryBudget(
      icon: Icons.fastfood_rounded,
      iconBg: Color(0xFFFFF3E0),
      iconColor: Color(0xFFF9A825),
      label: 'Food & Drinks',
      spent: 320,
      total: 500,
    ),
    _CategoryBudget(
      icon: Icons.directions_car_rounded,
      iconBg: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1565C0),
      label: 'Transport',
      spent: 180,
      total: 300,
    ),
    _CategoryBudget(
      icon: Icons.subscriptions_rounded,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFE53935),
      label: 'Subscriptions',
      spent: 284,
      total: 200,
    ),
    _CategoryBudget(
      icon: Icons.shopping_bag_rounded,
      iconBg: Color(0xFFEDE7F6),
      iconColor: Color(0xFF7B1FA2),
      label: 'Shopping',
      spent: 350,
      total: 600,
    ),
    _CategoryBudget(
      icon: Icons.home_rounded,
      iconBg: Color(0xFFE8F7F3),
      iconColor: Color(0xFF3DAA8E),
      label: 'Housing',
      spent: 150,
      total: 900,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Category Budgets',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => CategoryBudgetPage(),
                  binding: CategoryBudgetBinding(),
                );
              },
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3DAA8E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.addHeight(14),

        // Category list
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(_categories.length, (i) {
              return Column(
                children: [
                  _CategoryBudgetTile(data: _categories[i]),
                  if (i < _categories.length - 1)
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      indent: 72,
                      color: Colors.grey.shade100,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _CategoryBudget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final double spent;
  final double total;

  const _CategoryBudget({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.spent,
    required this.total,
  });

  double get progress => (spent / total).clamp(0.0, 1.0);
  bool get isOverBudget => spent > total;
}

class _CategoryBudgetTile extends StatelessWidget {
  final _CategoryBudget data;
  const _CategoryBudgetTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final progressColor =
        data.isOverBudget ? const Color(0xFFE53935) : const Color(0xFF3DAA8E);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(data.icon, size: 22, color: data.iconColor),
          ),
          const SizedBox(width: 14),

          // Label + bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${data.spent.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: progressColor,
                              fontFamily: 'Arial',
                            ),
                          ),
                          TextSpan(
                            text: ' / \$${data.total.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.addHeight(8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: data.progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                if (data.isOverBudget) ...[
                  AppSpacing.addHeight(4),
                  Text(
                    'Over budget by \$${(data.spent - data.total).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recent Expenses Section ──────────────────────────────────────────────────

class _RecentExpensesSection extends StatelessWidget {
  const _RecentExpensesSection();

  static const List<_ExpenseItem> _items = [
    _ExpenseItem(
      icon: Icons.play_arrow_rounded,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFFF0000),
      title: 'Youtube Premium',
      category: 'Subscriptions',
      date: 'Feb 28, 2022',
      amount: '- \$11.99',
    ),
    _ExpenseItem(
      icon: Icons.flash_on_rounded,
      iconBg: Color(0xFFFFF9C4),
      iconColor: Color(0xFFF9A825),
      title: 'Electricity Bill',
      category: 'Housing',
      date: 'Mar 28, 2022',
      amount: '- \$85.00',
    ),
    _ExpenseItem(
      icon: Icons.music_note_rounded,
      iconBg: Color(0xFFE8F5E9),
      iconColor: Color(0xFF1DB954),
      title: 'Spotify',
      category: 'Subscriptions',
      date: 'Feb 28, 2022',
      amount: '- \$9.99',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Expenses',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => RecentExpensePage(),
                  binding: RecentExpenseBinding(),
                );
              },
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3DAA8E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.addHeight(14),

        ...List.generate(_items.length, (i) {
          return Column(
            children: [
              _ExpenseTile(data: _items[i]),
              if (i < _items.length - 1)
                Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
            ],
          );
        }),
      ],
    );
  }
}

class _ExpenseItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String category;
  final String date;
  final String amount;

  const _ExpenseItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
  });
}

class _ExpenseTile extends StatelessWidget {
  final _ExpenseItem data;
  const _ExpenseTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(data.icon, size: 22, color: data.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.date,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE53935),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4FAF8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  data.category,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Add Budget Button ────────────────────────────────────────────────────────

class _AddBudgetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AddBudgetPage(), binding: AddBudgetBinding());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3DAA8E).withOpacity(0.20),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Add New Budget',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 22,
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFFFF7043),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
