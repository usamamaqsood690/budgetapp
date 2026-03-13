import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/bill_payment_receipt_page/bill_payment_receipt_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/bill_payment_receipt_page/binding/bill_payment_receipt_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/bill_detail/controller/bill_details_controller.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class BillPaymentPage extends StatelessWidget {
  const BillPaymentPage({super.key});

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
            CustomAppbarWithBack(title: 'Bill Payment'),

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
                        AppSpacing.addHeight(40),

                        // 3. Logo + description
                        const _ConfirmHero(),
                        AppSpacing.addHeight(40),

                        // 4. Price breakdown
                        const _PriceBreakdownCard(),
                        AppSpacing.addHeight(40),

                        // 5. Confirm button
                        const _ConfirmButton(),
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

// ─── Header ───────────────────────────────────────────────────────────────────

class _BillPaymentHeader extends StatelessWidget {
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
    );
  }
}

// ─── Confirm Hero ─────────────────────────────────────────────────────────────

class _ConfirmHero extends StatelessWidget {
  const _ConfirmHero();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillDetailController>();
    return Column(
      children: [
        // Youtube logo
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Color(0xFFFF0000),
            size: 32,
          ),
        ),
        AppSpacing.addHeight(24),

        // Description text with teal highlight
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1A1A2E),
              height: 1.6,
            ),
            children: [
              TextSpan(text: 'You will pay '),
              TextSpan(
                text: controller.description,
                style: TextStyle(
                  color: Color(0xFF3DAA8E),
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: '\nfor one month with BCA OneKlik'),
            ],
          ),
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
    final controller = Get.find<BillDetailController>();
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
          _PriceRow(
            label: 'Price',
            value: '\$ ' + controller.amount.toString(),
            bold: false,
          ),
          AppSpacing.addHeight(12),
          _PriceRow(label: 'Fee', value: '\$ 0', bold: false),
          AppSpacing.addHeight(16),
          Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
          AppSpacing.addHeight(16),
          _PriceRow(
            label: 'Total',
            value: '\$ ' + controller.amount.toString(),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? const Color(0xFF1A1A2E) : Colors.grey.shade500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

// ─── Confirm Button ───────────────────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillDetailController>();
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const BillPaymentReceiptPage(),
          binding: BillPaymentReceiptBinding(),
          arguments: {
            'amount': controller.amount,
            'date': controller.date,
            'category': controller.description,
            'description': controller.description,
            'transType': 'upcoming bill',
          },
        );
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
              color: const Color(0xFF3DAA8E).withOpacity(0.40),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Text(
          'Confirm and Pay',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
