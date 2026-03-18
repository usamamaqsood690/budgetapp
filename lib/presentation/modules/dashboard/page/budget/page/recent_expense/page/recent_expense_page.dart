import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class RecentExpensePage extends StatefulWidget {
  const RecentExpensePage({super.key});

  @override
  State<RecentExpensePage> createState() => _RecentExpensePageState();
}

class _RecentExpensePageState extends State<RecentExpensePage> {
  String _selectedCategory = 'All';

  static const List<_ExpenseItem> _allExpenses = [
    _ExpenseItem(
      icon: Icons.play_arrow_rounded,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFFF0000),
      title: 'Youtube Premium',
      category: 'Subscriptions',
      date: 'Feb 28, 2022',
      amount: -11.99,
    ),
    _ExpenseItem(
      icon: Icons.flash_on_rounded,
      iconBg: Color(0xFFFFF9C4),
      iconColor: Color(0xFFF9A825),
      title: 'Electricity Bill',
      category: 'Housing',
      date: 'Mar 28, 2022',
      amount: -85.00,
    ),
    _ExpenseItem(
      icon: Icons.music_note_rounded,
      iconBg: Color(0xFFE8F5E9),
      iconColor: Color(0xFF1DB954),
      title: 'Spotify',
      category: 'Subscriptions',
      date: 'Feb 28, 2022',
      amount: -9.99,
    ),
    _ExpenseItem(
      icon: Icons.local_cafe_rounded,
      iconBg: Color(0xFFFFF3E0),
      iconColor: Color(0xFFF9A825),
      title: 'Starbucks',
      category: 'Food & Drinks',
      date: 'Jan 12, 2022',
      amount: -150.00,
    ),
    _ExpenseItem(
      icon: Icons.directions_car_rounded,
      iconBg: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1565C0),
      title: 'Grab Ride',
      category: 'Transport',
      date: 'Mar 10, 2022',
      amount: -18.50,
    ),
    _ExpenseItem(
      icon: Icons.shopping_bag_rounded,
      iconBg: Color(0xFFEDE7F6),
      iconColor: Color(0xFF7B1FA2),
      title: 'Zara',
      category: 'Shopping',
      date: 'Mar 5, 2022',
      amount: -120.00,
    ),
    _ExpenseItem(
      icon: Icons.home_rounded,
      iconBg: Color(0xFFE8F7F3),
      iconColor: Color(0xFF3DAA8E),
      title: 'House Rent',
      category: 'Housing',
      date: 'Mar 31, 2022',
      amount: -650.00,
    ),
    _ExpenseItem(
      icon: Icons.movie_rounded,
      iconBg: Color(0xFFFCE4EC),
      iconColor: Color(0xFFC2185B),
      title: 'Netflix',
      category: 'Subscriptions',
      date: 'Feb 28, 2022',
      amount: -15.99,
    ),
    _ExpenseItem(
      icon: Icons.local_hospital_rounded,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFE53935),
      title: 'Pharmacy',
      category: 'Health',
      date: 'Mar 14, 2022',
      amount: -45.00,
    ),
    _ExpenseItem(
      icon: Icons.fastfood_rounded,
      iconBg: Color(0xFFFFF3E0),
      iconColor: Color(0xFFF9A825),
      title: 'McDonald\'s',
      category: 'Food & Drinks',
      date: 'Mar 8, 2022',
      amount: -22.50,
    ),
    _ExpenseItem(
      icon: Icons.school_rounded,
      iconBg: Color(0xFFE8F5E9),
      iconColor: Color(0xFF2E7D32),
      title: 'Udemy Course',
      category: 'Education',
      date: 'Mar 1, 2022',
      amount: -29.99,
    ),
    _ExpenseItem(
      icon: Icons.directions_bus_rounded,
      iconBg: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1565C0),
      title: 'Bus Pass',
      category: 'Transport',
      date: 'Mar 1, 2022',
      amount: -25.00,
    ),
  ];

  List<String> get _categories {
    final cats = {'All', ..._allExpenses.map((e) => e.category)};
    return cats.toList();
  }

  List<_ExpenseItem> get _filtered =>
      _selectedCategory == 'All'
          ? _allExpenses
          : _allExpenses.where((e) => e.category == _selectedCategory).toList();

  double get _totalFiltered => _filtered.fold(0.0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
            // 1. Header
            CustomAppbarWithBack(title: 'Recent Expenses'),

            // 3. Expense list grouped by date
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
                    // vertical: AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      AppSpacing.addHeight(12),
                      _TopExpensesSection(total: _totalFiltered),

                      AppSpacing.addHeight(12),
                      _CategoryFilterBar(
                        categories: _categories,
                        selected: _selectedCategory,
                        onSelected:
                            (c) => setState(() => _selectedCategory = c),
                      ),
                      AppSpacing.addHeight(4),

                      Expanded(
                        child:
                            filtered.isEmpty
                                ? const _EmptyState()
                                : ListView.builder(
                                  padding: AppSpacing.paddingSymmetric(
                                    horizontal: AppSpacing.z,
                                  ),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, i) {
                                    final item = filtered[i];
                                    final showHeader =
                                        i == 0 ||
                                        filtered[i - 1].date != item.date;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (showHeader) ...[
                                          AppSpacing.addHeight(16),
                                          _DateGroupHeader(date: item.date),
                                          AppSpacing.addHeight(8),
                                        ],
                                        _ExpenseTile(data: item),
                                        if (i < filtered.length - 1 &&
                                            filtered[i + 1].date == item.date)
                                          Divider(
                                            height: 1,
                                            thickness: 0.8,
                                            indent: 72,
                                            color: Colors.grey.shade100,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                      ),
                    ],
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

class _TopExpensesSection extends StatelessWidget {
  final double total;
  const _TopExpensesSection({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll(AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Total spent
          Text(
            'Total Spent',
            style: TextStyle(
              color: Colors.white.withOpacity(0.80),
              fontSize: 12,
            ),
          ),
          AppSpacing.addHeight(4),
          Text(
            '\$ ${total.abs().toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Filter Bar ──────────────────────────────────────────────────────

class _CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryFilterBar({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isActive = cat == selected;
          return GestureDetector(
            onTap: () => onSelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF3DAA8E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isActive ? const Color(0xFF3DAA8E) : Colors.grey.shade300,
                ),
                boxShadow:
                    isActive
                        ? [
                          BoxShadow(
                            color: const Color(0xFF3DAA8E).withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : [],
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Colors.grey.shade500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Date Group Header ────────────────────────────────────────────────────────

class _DateGroupHeader extends StatelessWidget {
  final String date;
  const _DateGroupHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF3DAA8E),
        letterSpacing: 0.3,
      ),
    );
  }
}

// ─── Expense Tile ─────────────────────────────────────────────────────────────

class _ExpenseItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String category;
  final String date;
  final double amount;

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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: data.iconBg,
              borderRadius: BorderRadius.circular(13),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
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
          ),

          Text(
            '- \$${data.amount.abs().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F7F3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 34,
              color: Color(0xFF3DAA8E),
            ),
          ),
          AppSpacing.addHeight(14),
          const Text(
            'No expenses found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          AppSpacing.addHeight(6),
          Text(
            'No expenses in this category yet.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
