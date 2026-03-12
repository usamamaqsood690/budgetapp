import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  String _selectedName = 'Netflix';
  String _amount = '48.00';
  String _date = 'Tue, 22 Feb 2022';

  static const List<Map<String, String>> _nameOptions = [
    {'label': 'Netflix', 'emoji': '🎬', 'color': 'E50914'},
    {'label': 'Youtube', 'emoji': '▶', 'color': 'FF0000'},
    {'label': 'Spotify', 'emoji': '🎵', 'color': '1DB954'},
    {'label': 'Electricity', 'emoji': '⚡', 'color': 'F9A825'},
    {'label': 'House Rent', 'emoji': '🏠', 'color': '3DAA8E'},
  ];

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
            // 1. Teal header
            CustomAppbar(title: 'Add Expense'),

            // 2. Form fields
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.addHeight(24),

                        // NAME
                        _FieldLabel(label: 'NAME'),
                        AppSpacing.addHeight(4),
                        _NameDropdown(
                          selected: _selectedName,
                          options: _nameOptions,
                          onChanged: (v) => setState(() => _selectedName = v),
                        ),
                        AppSpacing.addHeight(18),

                        // AMOUNT
                        _FieldLabel(label: 'AMOUNT'),
                        AppSpacing.addHeight(4),
                        _AmountField(
                          controller: TextEditingController(text: _amount),
                        ),
                        AppSpacing.addHeight(18),

                        // DATE
                        _FieldLabel(label: 'DATE'),
                        AppSpacing.addHeight(4),
                        _DateField(
                          date: _date,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2022, 2, 22),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                              builder:
                                  (ctx, child) => Theme(
                                    data: Theme.of(ctx).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF3DAA8E),
                                      ),
                                    ),
                                    child: child!,
                                  ),
                            );
                            if (picked != null) {
                              final days = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ];
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
                              setState(
                                () =>
                                    _date =
                                        '${days[picked.weekday - 1]}, '
                                        '${picked.day} '
                                        '${months[picked.month - 1]} '
                                        '${picked.year}',
                              );
                            }
                          },
                        ),
                        AppSpacing.addHeight(18),

                        // INVOICE
                        _FieldLabel(label: 'INVOICE'),
                        AppSpacing.addHeight(4),
                        const _InvoiceField(),

                        AppSpacing.addHeight(80),
                        // Spacer(),
                        _AddExpenceButton(),
                        // AppSpacing.addHeight(40),
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

// ─── Name Dropdown ────────────────────────────────────────────────────────────

class _NameDropdown extends StatelessWidget {
  final String selected;
  final List<Map<String, String>> options;
  final ValueChanged<String> onChanged;

  const _NameDropdown({
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      padding: AppSpacing.paddingSymmetric(
        horizontal: AppSpacing.spacing12,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22,
            color: Color(0xFF888888),
          ),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E),
          ),
          selectedItemBuilder:
              (context) =>
                  options.map((o) {
                    return Row(
                      children: [
                        _BrandLogo(emoji: o['emoji']!, colorHex: o['color']!),
                        const SizedBox(width: 10),
                        Text(
                          o['label']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
          items:
              options.map((o) {
                return DropdownMenuItem<String>(
                  value: o['label'],
                  child: Row(
                    children: [
                      _BrandLogo(emoji: o['emoji']!, colorHex: o['color']!),
                      const SizedBox(width: 10),
                      Text(
                        o['label']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  final String emoji;
  final String colorHex;

  const _BrandLogo({required this.emoji, required this.colorHex});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('FF$colorHex', radix: 16));
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 16)),
    );
  }
}

// ─── Amount Field ─────────────────────────────────────────────────────────────
class _AmountField extends StatelessWidget {
  final TextEditingController controller;

  const _AmountField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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

// ─── Date Field ───────────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  final String date;
  final VoidCallback onTap;

  const _DateField({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.calendar_month_outlined,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Invoice Field ────────────────────────────────────────────────────────────

class _InvoiceField extends StatelessWidget {
  const _InvoiceField();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFCCCCCC),
            style: BorderStyle.solid,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 20,
              color: Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              'Add Invoice',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Button ────────────────────────────────────────────────────────────

class _AddExpenceButton extends StatelessWidget {
  const _AddExpenceButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF3DAA8E), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Text(
          'Add Expence',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3DAA8E),
          ),
        ),
      ),
    );
  }
}
