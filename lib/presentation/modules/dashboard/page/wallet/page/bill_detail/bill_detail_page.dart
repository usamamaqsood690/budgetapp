import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/bill_detail/binding/bill_details_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/bill_detail/controller/bill_details_controller.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/bill_payment/bill_payment_page.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class BillDetailPage extends StatefulWidget {
  const BillDetailPage({super.key});

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  int _selectedPayment = 0; // 0 = Debit Card, 1 = Paypal

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
            CustomAppbarWithBack(title: 'Bill Details'),

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.addHeight(20),

                        // 3. Bill info card
                        _BillInfoCard(),
                        AppSpacing.addHeight(20),

                        // 4. Price breakdown
                        _PriceBreakdown(),
                        AppSpacing.addHeight(28),

                        // 5. Payment method selector
                        const Text(
                          'Select payment method',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        AppSpacing.addHeight(14),

                        _PaymentOption(
                          label: 'Debit Card',
                          isSelected: _selectedPayment == 0,
                          onTap: () => setState(() => _selectedPayment = 0),
                          leading: _DebitCardIcon(),
                        ),
                        AppSpacing.addHeight(12),

                        _PaymentOption(
                          label: 'Paypal',
                          isSelected: _selectedPayment == 1,
                          onTap: () => setState(() => _selectedPayment = 1),
                          leading: _PaypalIcon(),
                        ),
                        AppSpacing.addHeight(36),

                        // 6. Pay Now button
                        _PayNowButton(),
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

// ─── Bill Info Card ───────────────────────────────────────────────────────────

class _BillInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillDetailController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          // Youtube logo box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Color(0xFFFF0000),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),

          // Title + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.description ?? 'Demo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Feb 28, 2022',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Price Breakdown ──────────────────────────────────────────────────────────

class _PriceBreakdown extends StatelessWidget {
  final controller = Get.find<BillDetailController>();
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
      child: Column(
        children: [
          // Price row
          _PriceRow(
            label: 'Price',
            value: '\$ ${controller.amount}',
            bold: false,
          ),
          AppSpacing.addHeight(10),

          // Fee row
          _PriceRow(label: 'Fee', value: '', bold: false),
          AppSpacing.addHeight(14),

          Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
          AppSpacing.addHeight(14),

          // Total row
          _PriceRow(
            label: 'Total',
            value: '\$ ${controller.amount}',
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

// ─── Payment Option Tile ──────────────────────────────────────────────────────

class _PaymentOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget leading;

  const _PaymentOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F7F3) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF3DAA8E).withOpacity(0.3)
                    : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected
                          ? const Color(0xFF3DAA8E)
                          : const Color(0xFF1A1A2E),
                ),
              ),
            ),
            // Radio indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFF3DAA8E)
                          : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3DAA8E),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Payment Method Icons ─────────────────────────────────────────────────────

class _DebitCardIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF3DAA8E).withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.credit_card_rounded,
        color: Color(0xFF3DAA8E),
        size: 22,
      ),
    );
  }
}

class _PaypalIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'P',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: Color(0xFF003087),
        ),
      ),
    );
  }
}

// ─── Pay Now Button ───────────────────────────────────────────────────────────

class _PayNowButton extends StatelessWidget {
  const _PayNowButton();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillDetailController>();
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BillPaymentPage(),
          binding: BillDetailBinding(),
          arguments: {
            'amount': controller.amount,
            'date': controller.date,
            'category': controller.category,
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
          'Pay Now',
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
