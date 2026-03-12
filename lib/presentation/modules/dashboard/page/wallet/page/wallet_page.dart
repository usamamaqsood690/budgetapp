import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/detail_transaction_page/binding/detail_transaction_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/detail_transaction_page/detail_transaction_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/connect_wallet/binding/connect_wallet_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/wallet/page/connect_wallet/page/connect_wallet_page.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int _selectedTab = 0; // 0 = Transactions, 1 = Upcoming Bills

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
            CustomAppbar(title: 'Wallet'),

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
                      // 3. Balance + Action buttons (white card)
                      _BalanceCard(),
                      AppSpacing.addHeight(16),

                      // Tab bar
                      _WalletTabBar(
                        selectedIndex: _selectedTab,
                        onTabChanged: (i) => setState(() => _selectedTab = i),
                      ),
                      AppSpacing.addHeight(20),

                      // Tab content
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child:
                            _selectedTab == 0
                                ? const _TransactionsList(key: ValueKey('tx'))
                                : const _UpcomingBillsList(
                                  key: ValueKey('bills'),
                                ),
                      ),
                      AppSpacing.addHeight(24),
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

// ─── Balance Card ─────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll(AppSpacing.md),
      child: Column(
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
            ),
          ),
          AppSpacing.addHeight(6),
          const Text(
            '\$ 2,548.00',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          AppSpacing.addHeight(24),

          // Action buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(icon: Icons.add, label: 'Add'),
              _ActionButton(icon: Icons.grid_view_rounded, label: 'Pay'),
              _ActionButton(icon: Icons.send_rounded, label: 'Send'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3DAA8E), width: 1.5),
              color: Colors.white,
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF3DAA8E)),
          ),
          AppSpacing.addHeight(6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab Bar ──────────────────────────────────────────────────────────────────

class _WalletTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _WalletTabBar({
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
            label: 'Transactions',
            isActive: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            label: 'Upcoming Bills',
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

// ─── Transactions List ────────────────────────────────────────────────────────

class _TransactionsList extends StatelessWidget {
  const _TransactionsList({super.key});

  static const List<_TxData> _items = [
    _TxData(
      logo: _TxLogo.upwork,
      title: 'Upwork',
      subtitle: 'Today',
      amount: '850.00',
      transType: 'Income',
      isPositive: true,
    ),
    _TxData(
      logo: _TxLogo.transfer,
      title: 'Transfer',
      subtitle: 'Yesterday',
      amount: '85.00',
      transType: 'Expense',
      isPositive: false,
    ),
    _TxData(
      logo: _TxLogo.paypal,
      title: 'Paypal',
      subtitle: 'Jan 30, 2022',
      amount: '1,406.00',
      transType: 'Income',
      isPositive: true,
    ),
    _TxData(
      logo: _TxLogo.youtube,
      title: 'Youtube',
      subtitle: 'Jan 16, 2022',
      amount: '11.99',
      transType: 'Expense',
      isPositive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_items.length, (i) {
        final tx = _items[i];
        return Column(
          children: [
            _TransactionTile(data: tx),
            if (i < _items.length - 1)
              Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
          ],
        );
      }),
    );
  }
}

enum _TxLogo { upwork, transfer, paypal, youtube }

class _TxData {
  final _TxLogo logo;
  final String title;
  final String subtitle;
  final String amount;
  final String transType;
  final bool isPositive;

  const _TxData({
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.transType,
    required this.isPositive,
  });
}

class _TransactionTile extends StatelessWidget {
  final _TxData data;
  const _TransactionTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const DetailTransactionPage(),
          binding: DetailTransactionBinding(),
          arguments: {
            'amount': data.amount,
            'date': data.subtitle,
            'category': data.title,
            'description': data.title,
            'transType': data.transType,
          },
        );
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _TxLogoWidget(logo: data.logo),
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
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Text(
              "\$ " + data.amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color:
                    data.isPositive
                        ? const Color(0xFF3DAA8E)
                        : const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TxLogoWidget extends StatelessWidget {
  final _TxLogo logo;
  const _TxLogoWidget({required this.logo});

  @override
  Widget build(BuildContext context) {
    switch (logo) {
      case _TxLogo.upwork:
        return _LogoBox(
          color: const Color(0xFFE8F5E9),
          child: const Text(
            'Up',
            style: TextStyle(
              color: Color(0xFF14A800),
              fontWeight: FontWeight.w800,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      case _TxLogo.transfer:
        return _LogoBox(
          color: const Color(0xFFE3F2FD),
          child: const Icon(
            Icons.swap_horiz_rounded,
            color: Color(0xFF1565C0),
            size: 22,
          ),
        );
      case _TxLogo.paypal:
        return _LogoBox(
          color: const Color(0xFFE8EAF6),
          child: const Text(
            'P',
            style: TextStyle(
              color: Color(0xFF003087),
              fontWeight: FontWeight.w900,
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      case _TxLogo.youtube:
        return _LogoBox(
          color: const Color(0xFFFFEBEE),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Color(0xFFFF0000),
            size: 24,
          ),
        );
    }
  }
}

// ─── Upcoming Bills List ──────────────────────────────────────────────────────

class _UpcomingBillsList extends StatelessWidget {
  const _UpcomingBillsList({super.key});

  static const List<_BillData> _items = [
    _BillData(
      logo: _BillLogo.youtube,
      title: 'Youtube',
      date: 'Feb 28, 2022',
      amount: "25",
    ),
    _BillData(
      logo: _BillLogo.electricity,
      title: 'Electricity',
      date: 'Mar 28, 2022',
      amount: "120",
    ),
    _BillData(
      logo: _BillLogo.houseRent,
      title: 'House Rent',
      date: 'Mar 31, 2022',
      amount: "850",
    ),
    _BillData(
      logo: _BillLogo.spotify,
      title: 'Spotify',
      date: 'Feb 28, 2022',
      amount: "9.99",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_items.length, (i) {
        final bill = _items[i];
        return Column(
          children: [
            _BillTile(data: bill),
            if (i < _items.length - 1)
              Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
          ],
        );
      }),
    );
  }
}

enum _BillLogo { youtube, electricity, houseRent, spotify }

class _BillData {
  final _BillLogo logo;
  final String title;
  final String date;
  final String amount;

  const _BillData({
    required this.logo,
    required this.title,
    required this.date,
    required this.amount,
  });
}

class _BillTile extends StatelessWidget {
  final _BillData data;
  const _BillTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _BillLogoWidget(logo: data.logo),
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
                const SizedBox(height: 2),
                Text(
                  data.date,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Pay button
          GestureDetector(
            onTap: () {
              Get.to(
                () => ConnectWalletPage(),
                binding: ConnectWalletBinding(),
                arguments: {
                  'amount': data.amount,
                  'date': data.date,
                  'category': data.title,
                  'description': data.title,
                  'transType': 'upcoming bill',
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7F3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Pay',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3DAA8E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillLogoWidget extends StatelessWidget {
  final _BillLogo logo;
  const _BillLogoWidget({required this.logo});

  @override
  Widget build(BuildContext context) {
    switch (logo) {
      case _BillLogo.youtube:
        return _LogoBox(
          color: const Color(0xFFFFEBEE),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Color(0xFFFF0000),
            size: 24,
          ),
        );
      case _BillLogo.electricity:
        return _LogoBox(
          color: const Color(0xFFFFF9C4),
          child: const Icon(
            Icons.flash_on_rounded,
            color: Color(0xFFF9A825),
            size: 22,
          ),
        );
      case _BillLogo.houseRent:
        return _LogoBox(
          color: const Color(0xFFE8F7F3),
          child: const Icon(
            Icons.home_rounded,
            color: Color(0xFF3DAA8E),
            size: 22,
          ),
        );
      case _BillLogo.spotify:
        return _LogoBox(
          color: const Color(0xFFE8F5E9),
          child: const Icon(
            Icons.music_note_rounded,
            color: Color(0xFF1DB954),
            size: 22,
          ),
        );
    }
  }
}

// ─── Shared: Logo Box ─────────────────────────────────────────────────────────

class _LogoBox extends StatelessWidget {
  final Color color;
  final Widget child;

  const _LogoBox({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
