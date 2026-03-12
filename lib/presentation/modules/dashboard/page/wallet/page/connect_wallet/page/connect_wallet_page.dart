import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/bill_payment_receipt_page/bill_payment_receipt_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/bill_payment_receipt_page/binding/bill_payment_receipt_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/connect_wallet/controller/connect_wallet_controller.dart';

class ConnectWalletPage extends StatefulWidget {
  const ConnectWalletPage({super.key});

  @override
  State<ConnectWalletPage> createState() => _ConnectWalletPageState();
}

class _ConnectWalletPageState extends State<ConnectWalletPage> {
  int _selectedTab = 0; // 0 = Cards, 1 = Accounts
  int _selectedAccount = 0; // 0 = Bank Link (default selected)

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
            // CustomAppbar(title: 'Connect Wallet'),
            _ConnectWalletHeader(),
            // 2. Body
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
                        // AppSpacing.addHeight(24),
                        AppSpacing.addHeight(32),

                        // 3. Tab selector
                        _ConnectWalletTabBar(
                          selectedIndex: _selectedTab,
                          onTabChanged: (i) => setState(() => _selectedTab = i),
                        ),

                        AppSpacing.addHeight(28),

                        // 4. Tab content
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child:
                              _selectedTab == 0
                                  ? _CardsTab(key: const ValueKey('cards'))
                                  : _AccountsTab(
                                    key: const ValueKey('accounts'),
                                    selectedIndex: _selectedAccount,
                                    onSelected:
                                        (i) => setState(
                                          () => _selectedAccount = i,
                                        ),
                                  ),
                        ),

                        AppSpacing.addHeight(40),

                        // 5. Next button (only on Accounts tab)
                        if (_selectedTab == 1) ...[
                          _NextButton(),
                          AppSpacing.addHeight(24),
                        ],
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

// ─── Teal Header ──────────────────────────────────────────────────────────────

class _ConnectWalletHeader extends StatelessWidget {
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
                    'Connect Wallet',
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

// ─── Tab Bar ──────────────────────────────────────────────────────────────────

class _ConnectWalletTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _ConnectWalletTabBar({
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAll(AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Cards',
            isActive: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            label: 'Accounts',
            isActive: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: AppSpacing.paddingVertical(AppSpacing.spacing10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Cards Tab ────────────────────────────────────────────────────────────────

class _CardsTab extends StatefulWidget {
  const _CardsTab({super.key});

  @override
  State<_CardsTab> createState() => _CardsTabState();
}

class _CardsTabState extends State<_CardsTab> {
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvcController = TextEditingController();
  final _expiryController = TextEditingController();
  final _zipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _cvcController.dispose();
    _expiryController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Debit card visual
        _DebitCardWidget(name: _nameController.text),
        AppSpacing.addHeight(28),

        // Title
        const Text(
          'Add your debit Card',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        AppSpacing.addHeight(4),
        Text(
          'This card must be connected to a bank account\nunder your name',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
            height: 1.5,
          ),
        ),
        AppSpacing.addHeight(20),

        // Name on card field (outlined/active)
        _OutlinedInputField(
          label: 'NAME ON CARD',
          controller: _nameController,
          // isActive: true,
        ),
        AppSpacing.addHeight(12),

        // Card number + CVC row
        Row(
          children: [
            Expanded(
              child: _OutlinedInputField(
                label: 'DEBIT CARD NUMBER',
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OutlinedInputField(
                label: 'CVC',
                controller: _cvcController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        AppSpacing.addHeight(12),

        // Expiry + ZIP row
        Row(
          children: [
            Expanded(
              child: _OutlinedInputField(
                label: 'EXPIRATION MM/YY',
                controller: _expiryController,
                keyboardType: TextInputType.datetime,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OutlinedInputField(
                label: 'ZIP',
                controller: _zipController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        AppSpacing.addHeight(32),

        // Next button
        _NextButton(),
        AppSpacing.addHeight(24),
      ],
    );
  }
}

// ─── Debit Card Visual ────────────────────────────────────────────────────────

class _DebitCardWidget extends StatelessWidget {
  final String name;
  const _DebitCardWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Back card (slightly visible at top)
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 0),
          child: Container(
            height: 190,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4ECBA8), Color(0xFF2D9E80)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        // Front card
        Padding(
          padding: const EdgeInsets.only(top: 12, right: 16),
          child: Container(
            height: 190,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3DAA8E), Color(0xFF1E7A62)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3DAA8E).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card type + bank name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debit',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Card',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Mono',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                AppSpacing.addHeight(10),

                // Chip icon
                Container(
                  width: 36,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    color: Colors.white54,
                    size: 18,
                  ),
                ),

                const Spacer(),

                // Card number
                Text(
                  '6219   8610   2888   8075',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                AppSpacing.addHeight(10),

                // Name + expiry
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'CARD HOLDER',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      '22/01',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Outlined Input Field ─────────────────────────────────────────────────────

class _OutlinedInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isActive;
  final TextInputType keyboardType;

  const _OutlinedInputField({
    required this.label,
    required this.controller,
    this.isActive = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF3DAA8E),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF3DAA8E) : Colors.grey.shade400,
          letterSpacing: 0.5,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isActive ? const Color(0xFF3DAA8E) : Colors.grey.shade300,
            width: isActive ? 1.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3DAA8E), width: 1.5),
        ),
      ),
    );
  }
}

// ─── Accounts Tab ─────────────────────────────────────────────────────────────

class _AccountsTab extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _AccountsTab({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<_AccountOption> _options = [
    _AccountOption(
      icon: Icons.account_balance_rounded,
      title: 'Bank Link',
      subtitle: 'Connect your bank account to deposit & fund',
      iconBg: Color(0xFFE8F7F3),
      iconColor: Color(0xFF3DAA8E),
    ),
    _AccountOption(
      icon: Icons.attach_money_rounded,
      title: 'Microdeposits',
      subtitle: 'Connect bank in 5-7 days',
      iconBg: Color(0xFFEEEEEE),
      iconColor: Color(0xFF888888),
    ),
    _AccountOption(
      icon: Icons.paypal_rounded,
      title: 'Paypal',
      subtitle: 'Connect you paypal account',
      iconBg: Color(0xFFEEEEEE),
      iconColor: Color(0xFF888888),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_options.length, (i) {
        final opt = _options[i];
        final isSelected = i == selectedIndex;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _AccountOptionTile(
            option: opt,
            isSelected: isSelected,
            onTap: () => onSelected(i),
          ),
        );
      }),
    );
  }
}

class _AccountOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBg;
  final Color iconColor;

  const _AccountOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBg,
    required this.iconColor,
  });
}

class _AccountOptionTile extends StatelessWidget {
  final _AccountOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccountOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F7F3) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF3DAA8E) : Colors.transparent,
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
            // Icon box
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : option.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                option.icon,
                size: 24,
                color: isSelected ? const Color(0xFF3DAA8E) : option.iconColor,
              ),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color:
                          isSelected
                              ? const Color(0xFF3DAA8E)
                              : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    option.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Checkmark
            if (isSelected) ...[
              const SizedBox(width: 10),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF3DAA8E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Next Button ──────────────────────────────────────────────────────────────

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectWalletController controller =
        Get.find<ConnectWalletController>();
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
          'Next',
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
