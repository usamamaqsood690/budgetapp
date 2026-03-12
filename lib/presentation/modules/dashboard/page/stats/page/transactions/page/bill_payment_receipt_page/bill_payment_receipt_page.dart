import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/bill_payment_receipt_page/controller/bill_payment_receipt_controller.dart';

class BillPaymentReceiptPage extends StatefulWidget {
  const BillPaymentReceiptPage({super.key});

  @override
  State<BillPaymentReceiptPage> createState() => _BillPaymentReceiptPageState();
}

class _BillPaymentReceiptPageState extends State<BillPaymentReceiptPage> {
  bool _detailsExpanded = true;

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
            _BillPaymentHeader(),

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
                  child: Column(
                    children: [
                      AppSpacing.addHeight(32),

                      // 3. Success icon + title
                      const _PaymentSuccessBadge(),
                      AppSpacing.addHeight(32),

                      // 4. Transaction details card
                      _TransactionDetailsCard(
                        expanded: _detailsExpanded,
                        onToggle:
                            () => setState(
                              () => _detailsExpanded = !_detailsExpanded,
                            ),
                      ),
                      AppSpacing.addHeight(20),

                      // 5. Price breakdown card
                      const _PriceBreakdownCard(),
                      // AppSpacing.addHeight(32),
                      Spacer(),

                      // 6. Share Receipt button
                      const _ShareReceiptButton(),
                      AppSpacing.addHeight(70),
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

// ─── Teal Header ──────────────────────────────────────────────────────────────

class _BillPaymentHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: double.infinity,
        padding: AppSpacing.paddingSymmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.addHeight(40),
            // Greeting row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Bill Payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.more_horiz, size: 24, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Payment Success Badge ────────────────────────────────────────────────────

class _PaymentSuccessBadge extends StatelessWidget {
  const _PaymentSuccessBadge();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillPaymentReceiptController>();
    return Column(
      children: [
        // Teal circle checkmark
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: Color(0xFF3DAA8E),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 30),
        ),
        AppSpacing.addHeight(16),

        const Text(
          'Payment Successfully',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3DAA8E),
          ),
        ),
        AppSpacing.addHeight(6),

        Text(
          controller.description ?? '',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

// ─── Transaction Details Card ─────────────────────────────────────────────────

class _TransactionDetailsCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const _TransactionDetailsCard({
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillPaymentReceiptController>();
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
      child: Column(
        children: [
          // Header row
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: const Color(0xFF888888),
                ),
              ],
            ),
          ),

          // Expandable rows
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                AppSpacing.addHeight(16),
                _DetailRow(
                  label: 'Payment method',
                  value: 'Debit Card',
                  valueStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                AppSpacing.addHeight(12),
                _DetailRow(
                  label: 'Status',
                  value: 'Completed',
                  valueStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3DAA8E),
                  ),
                ),
                AppSpacing.addHeight(12),
                _DetailRow(
                  label: 'Time',
                  value: '08:15 AM',
                  valueStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                AppSpacing.addHeight(12),
                _DetailRow(
                  label: 'Date',
                  value: '${controller.date}',
                  valueStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                AppSpacing.addHeight(12),
                _TransactionIdRow(),
              ],
            ),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _TransactionIdRow extends StatelessWidget {
  final String _txId = '2092913832472';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transaction ID',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
        ),
        Row(
          children: [
            Text(
              '${_txId.substring(0, 13)}..',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _txId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction ID copied'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7F3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.copy_rounded,
                  size: 14,
                  color: Color(0xFF3DAA8E),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Price Breakdown Card ─────────────────────────────────────────────────────

class _PriceBreakdownCard extends StatelessWidget {
  const _PriceBreakdownCard();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillPaymentReceiptController>();
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
      child: Column(
        children: [
          // Price row
          _DetailRow(
            label: 'Price',
            value: '\$ ${controller.amount}',
            valueStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
          ),
          AppSpacing.addHeight(12),

          // Fee row
          _DetailRow(
            label: 'Fee',
            value: '\$ 0',
            valueStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
          ),

          AppSpacing.addHeight(16),

          // Divider
          Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
          AppSpacing.addHeight(16),

          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                '\$ ${controller.amount}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Share Receipt Button ─────────────────────────────────────────────────────

class _ShareReceiptButton extends StatelessWidget {
  const _ShareReceiptButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
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
          'Share Receipt',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3DAA8E),
          ),
        ),
      ),
    );
  }
}
