import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final TextEditingController _budgetNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  _CategoryOption? _selectedCategory;
  int _selectedPeriod = 1; // 0=Weekly, 1=Monthly, 2=Yearly
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  final List<String> _periods = ['Weekly', 'Monthly', 'Yearly'];

  static const List<_CategoryOption> _categories = [
    _CategoryOption(
      icon: Icons.fastfood_rounded,
      iconBg: Color(0xFFFFF3E0),
      iconColor: Color(0xFFF9A825),
      label: 'Food & Drinks',
    ),
    _CategoryOption(
      icon: Icons.directions_car_rounded,
      iconBg: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1565C0),
      label: 'Transport',
    ),
    _CategoryOption(
      icon: Icons.subscriptions_rounded,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFE53935),
      label: 'Subscriptions',
    ),
    _CategoryOption(
      icon: Icons.shopping_bag_rounded,
      iconBg: Color(0xFFEDE7F6),
      iconColor: Color(0xFF7B1FA2),
      label: 'Shopping',
    ),
    _CategoryOption(
      icon: Icons.home_rounded,
      iconBg: Color(0xFFE8F7F3),
      iconColor: Color(0xFF3DAA8E),
      label: 'Housing',
    ),
    _CategoryOption(
      icon: Icons.local_hospital_rounded,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFE53935),
      label: 'Health',
    ),
    _CategoryOption(
      icon: Icons.school_rounded,
      iconBg: Color(0xFFE8F5E9),
      iconColor: Color(0xFF2E7D32),
      label: 'Education',
    ),
    _CategoryOption(
      icon: Icons.movie_rounded,
      iconBg: Color(0xFFFCE4EC),
      iconColor: Color(0xFFC2185B),
      label: 'Entertainment',
    ),
  ];

  String _formatDate(DateTime d) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder:
          (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFF3DAA8E)),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  bool get _isFormValid =>
      _selectedCategory != null &&
      _amountController.text.isNotEmpty &&
      double.tryParse(_amountController.text) != null;

  @override
  void dispose() {
    _budgetNameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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
            // _AddBudgetHeader(),
            CustomAppbarWithBack(title: 'Add Budget'),

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
                    // vertical: AppSpacing.sm,
                  ),
                  child: SingleChildScrollView(
                    // padding: AppSpacing.paddingSymmetric(
                    //   horizontal: AppSpacing.md,
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.addHeight(24),

                        // 3. Category picker
                        _FieldLabel(label: 'CATEGORY'),
                        AppSpacing.addHeight(12),
                        _CategoryGrid(
                          categories: _categories,
                          selected: _selectedCategory,
                          onSelected:
                              (c) => setState(() => _selectedCategory = c),
                        ),
                        AppSpacing.addHeight(20),

                        // 4. Budget name
                        _FieldLabel(label: 'BUDGET NAME'),
                        AppSpacing.addHeight(8),
                        _InputField(
                          controller: _budgetNameController,
                          hint: 'e.g. Monthly Groceries',
                        ),
                        AppSpacing.addHeight(18),

                        // 5. Amount
                        _FieldLabel(label: 'BUDGET AMOUNT'),
                        AppSpacing.addHeight(8),
                        _AmountInputField(
                          controller: _amountController,
                          onChanged: (_) => setState(() {}),
                        ),
                        AppSpacing.addHeight(18),

                        // 6. Period selector
                        _FieldLabel(label: 'PERIOD'),
                        AppSpacing.addHeight(10),
                        _PeriodSelector(
                          periods: _periods,
                          selectedIndex: _selectedPeriod,
                          onSelected:
                              (i) => setState(() => _selectedPeriod = i),
                        ),
                        AppSpacing.addHeight(18),

                        // 7. Date range
                        _FieldLabel(label: 'DATE RANGE'),
                        AppSpacing.addHeight(10),
                        _DateRangeRow(
                          startDate: _formatDate(_startDate),
                          endDate: _formatDate(_endDate),
                          onStartTap: () => _pickDate(true),
                          onEndTap: () => _pickDate(false),
                        ),
                        AppSpacing.addHeight(18),

                        // 8. Notes
                        _FieldLabel(label: 'NOTES (OPTIONAL)'),
                        AppSpacing.addHeight(8),
                        _NotesField(controller: _notesController),
                        AppSpacing.addHeight(32),

                        // 9. Save button
                        _SaveBudgetButton(
                          isEnabled: _isFormValid,
                          onTap:
                              _isFormValid
                                  ? () => Navigator.pop(context)
                                  : null,
                        ),
                        AppSpacing.addHeight(24),
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

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF888888),
        letterSpacing: 1.0,
      ),
    );
  }
}

// ─── Category Grid ────────────────────────────────────────────────────────────

class _CategoryOption {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;

  const _CategoryOption({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
  });
}

class _CategoryGrid extends StatelessWidget {
  final List<_CategoryOption> categories;
  final _CategoryOption? selected;
  final ValueChanged<_CategoryOption> onSelected;

  const _CategoryGrid({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      padding: EdgeInsets.all(0),
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final cat = categories[i];
        final isSelected = selected?.label == cat.label;
        return GestureDetector(
          onTap: () => onSelected(cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8F7F3) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                    isSelected ? const Color(0xFF3DAA8E) : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : cat.iconBg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    cat.icon,
                    size: 20,
                    color: isSelected ? const Color(0xFF3DAA8E) : cat.iconColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color:
                        isSelected
                            ? const Color(0xFF3DAA8E)
                            : const Color(0xFF1A1A2E),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Input Field ──────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3DAA8E), width: 1.5),
        ),
      ),
    );
  }
}

// ─── Amount Input Field ───────────────────────────────────────────────────────

class _AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _AmountInputField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF3DAA8E),
      ),
      decoration: InputDecoration(
        prefixText: '\$ ',
        prefixStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3DAA8E),
        ),
        hintText: '0.00',
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3DAA8E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3DAA8E), width: 1.5),
        ),
      ),
    );
  }
}

// ─── Period Selector ──────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _PeriodSelector({
    required this.periods,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(periods.length, (i) {
          final isActive = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      isActive ? const Color(0xFF3DAA8E) : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Text(
                  periods[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? Colors.white : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Date Range Row ───────────────────────────────────────────────────────────

class _DateRangeRow extends StatelessWidget {
  final String startDate;
  final String endDate;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  const _DateRangeRow({
    required this.startDate,
    required this.endDate,
    required this.onStartTap,
    required this.onEndTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DatePickerBox(
            label: 'Start Date',
            date: startDate,
            onTap: onStartTap,
          ),
        ),
        const SizedBox(width: 12),
        const Icon(
          Icons.arrow_forward_rounded,
          size: 18,
          color: Color(0xFF3DAA8E),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DatePickerBox(
            label: 'End Date',
            date: endDate,
            onTap: onEndTap,
          ),
        ),
      ],
    );
  }
}

class _DatePickerBox extends StatelessWidget {
  final String label;
  final String date;
  final VoidCallback onTap;

  const _DatePickerBox({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Notes Field ──────────────────────────────────────────────────────────────

class _NotesField extends StatelessWidget {
  final TextEditingController controller;

  const _NotesField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: 'Add a note about this budget...',
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3DAA8E), width: 1.5),
        ),
      ),
    );
  }
}

// ─── Save Budget Button ───────────────────────────────────────────────────────

class _SaveBudgetButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onTap;

  const _SaveBudgetButton({required this.isEnabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient:
              isEnabled
                  ? const LinearGradient(
                    colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isEnabled ? null : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
          boxShadow:
              isEnabled
                  ? [
                    BoxShadow(
                      color: const Color(0xFF3DAA8E).withOpacity(0.40),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : [],
        ),
        child: Text(
          'Save Budget',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isEnabled ? Colors.white : Colors.grey.shade500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
