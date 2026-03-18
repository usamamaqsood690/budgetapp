import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class CategoryBudgetPage extends StatefulWidget {
  const CategoryBudgetPage({super.key});

  @override
  State<CategoryBudgetPage> createState() => _CategoryBudgetPageState();
}

class _CategoryBudgetPageState extends State<CategoryBudgetPage> {
  String _sortBy = 'Most Spent'; // Most Spent | Remaining | A-Z

  static const List<_CategoryBudget> _allCategories = [
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
      icon: Icons.home_rounded,
      iconBg: Color(0xFFE8F7F3),
      iconColor: Color(0xFF3DAA8E),
      label: 'Housing',
      spent: 150,
      total: 900,
    ),
    _CategoryBudget(
      icon: Icons.local_hospital_rounded,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFE53935),
      label: 'Health',
      spent: 90,
      total: 200,
    ),
    _CategoryBudget(
      icon: Icons.movie_rounded,
      iconBg: Color(0xFFFCE4EC),
      iconColor: Color(0xFFC2185B),
      label: 'Entertainment',
      spent: 60,
      total: 150,
    ),
    _CategoryBudget(
      icon: Icons.school_rounded,
      iconBg: Color(0xFFE8F5E9),
      iconColor: Color(0xFF2E7D32),
      label: 'Education',
      spent: 50,
      total: 300,
    ),
  ];

  List<_CategoryBudget> get _sorted {
    final list = List<_CategoryBudget>.from(_allCategories);
    switch (_sortBy) {
      case 'Most Spent':
        list.sort((a, b) => b.spent.compareTo(a.spent));
        break;
      case 'Remaining':
        list.sort((a, b) => (a.total - a.spent).compareTo(b.total - b.spent));
        break;
      case 'A-Z':
        list.sort((a, b) => a.label.compareTo(b.label));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted;
    final overBudget = sorted.where((c) => c.isOverBudget).length;
    final onTrack = sorted.length - overBudget;

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
            // _PageHeader(title: 'Category Budgets'),
            CustomAppbarWithBack(title: 'Category Budgets'),

            // 4. List
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
                      // 2. Summary strip
                      _SummaryStrip(
                        totalCategories: sorted.length,
                        overBudget: overBudget,
                        onTrack: onTrack,
                      ),
                      AppSpacing.addHeight(12),
                      // 3. Sort bar
                      Padding(
                        padding: AppSpacing.paddingSymmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: _SortBar(
                          sortBy: _sortBy,
                          onChanged: (v) => setState(() => _sortBy = v),
                        ),
                      ),
                      AppSpacing.addHeight(12),
                      Expanded(
                        child: ListView.separated(
                          padding: AppSpacing.paddingSymmetric(
                            // horizontal: AppSpacing.md,
                            vertical: AppSpacing.z,
                          ),
                          itemCount: sorted.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder:
                              (context, i) =>
                                  _CategoryBudgetCard(data: sorted[i]),
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

class _PageHeader extends StatelessWidget {
  final String title;
  const _PageHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const Icon(Icons.more_horiz, size: 24, color: Colors.white),
        ],
      ),
    );
  }
}

// ─── Summary Strip ────────────────────────────────────────────────────────────

class _SummaryStrip extends StatelessWidget {
  final int totalCategories;
  final int overBudget;
  final int onTrack;

  const _SummaryStrip({
    required this.totalCategories,
    required this.overBudget,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      padding: AppSpacing.paddingAll(AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StripStat(
            value: '$totalCategories',
            label: 'Total',
            color: Colors.white,
          ),
          _StripDivider(),
          _StripStat(value: '$onTrack', label: 'On Track', color: Colors.white),
          _StripDivider(),
          _StripStat(
            value: '$overBudget',
            label: 'Over Budget',
            color: Colors.redAccent.shade100,
          ),
        ],
      ),
    );
  }
}

class _StripStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StripStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.85)),
        ),
      ],
    );
  }
}

class _StripDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.25),
    );
  }
}

// ─── Sort Bar ─────────────────────────────────────────────────────────────────

class _SortBar extends StatelessWidget {
  final String sortBy;
  final ValueChanged<String> onChanged;

  const _SortBar({required this.sortBy, required this.onChanged});

  static const _options = ['Most Spent', 'Remaining', 'A-Z'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Sort by:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        ..._options.map((opt) {
          final isActive = opt == sortBy;
          return GestureDetector(
            onTap: () => onChanged(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF3DAA8E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isActive ? const Color(0xFF3DAA8E) : Colors.grey.shade300,
                ),
              ),
              child: Text(
                opt,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Colors.grey.shade500,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Category Budget Card ─────────────────────────────────────────────────────

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
  double get remaining => total - spent;
}

class _CategoryBudgetCard extends StatelessWidget {
  final _CategoryBudget data;
  const _CategoryBudgetCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final progressColor =
        data.isOverBudget ? const Color(0xFFE53935) : const Color(0xFF3DAA8E);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            data.isOverBudget
                ? Border.all(
                  color: const Color(0xFFE53935).withOpacity(0.3),
                  width: 1,
                )
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
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

              // Label + over badge
              Expanded(
                child: Row(
                  children: [
                    Text(
                      data.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    if (data.isOverBudget) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Over',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Spent / Total
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${data.spent.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
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
                  const SizedBox(height: 2),
                  Text(
                    data.isOverBudget
                        ? 'Over by \$${(data.spent - data.total).toStringAsFixed(0)}'
                        : '\$${data.remaining.toStringAsFixed(0)} left',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          data.isOverBudget
                              ? const Color(0xFFE53935)
                              : Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.addHeight(12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: data.progress,
              minHeight: 7,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          AppSpacing.addHeight(8),

          // Percentage label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(data.progress * 100).toStringAsFixed(0)}% used',
                style: TextStyle(
                  fontSize: 11,
                  color: progressColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Budget: \$${data.total.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
