// import 'package:flutter/material.dart';
// import 'package:wealthnxai/core/constants/app_images_path.dart';
// import 'package:wealthnxai/core/themes/app_spacing.dart';
// import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/schedule_section/schedule_section.dart';
// import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/discord_card.dart';
// import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/portfolio_section.dart';
// import 'package:wealthnxai/presentation/modules/dashboard/page/home/widget/top_mover.dart';
// import 'package:wealthnxai/presentation/modules/news/page/news_section.dart';
// import '../widget/ask_genie_card.dart';
// import '../widget/financial_snapshot.dart';
// import '../widget/home_greeting.dart';
// import '../widget/home_header.dart';

// // Note: You can add 'today_movers_section.dart' and 'home_community_card.dart' similarly

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: AppSpacing.responTextHeight(50)),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(ImagePaths.grad),
//           fit: BoxFit.contain,
//           alignment: Alignment.topLeft,
//         ),
//       ),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
//           child: Column(
//             children: [
//               // 1. Header
//               HomeHeader(),
//               AppSpacing.addHeight(21),

//               // 2. Greeting
//               const HomeGreeting(),
//               AppSpacing.addHeight(12),

//               // 3. Ask Genie
//               const AskGenieCard(),
//               AppSpacing.addHeight(30),

//               // 4. Portfolio (Agents)
//               const PortfolioSection(),
//               AppSpacing.addHeight(30),

//               // 5. Financial Snapshot
//               FinancialSnapshot(),
//               AppSpacing.addHeight(30),

//               // 6. Top Mover
//               const TopMover(),
//               AppSpacing.addHeight(30),

//               // 7. Schedule
//               const ScheduleSection(),
//               AppSpacing.addHeight(30),

//               const DiscordCard(),
//               AppSpacing.addHeight(30),

//               // 8. News
//               NewsSection(),
//               //   const NewsSection(),
//               AppSpacing.addHeight(30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

// ─── Entry Page ───────────────────────────────────────────────────────────────

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Teal header card (greeting + balance + income/expense)
            const WalletHeaderCard(),

            Padding(
              padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  AppSpacing.addHeight(24),

                  // 2. Transaction History
                  const TransactionHistorySection(),
                  AppSpacing.addHeight(28),

                  // 3. Send Again
                  const SendAgainSection(),
                  AppSpacing.addHeight(28),
                ],
              ),
            ),
          ],
        ),
      ),

      // // 4. Bottom Nav Bar
      // bottomNavigationBar: const WalletBottomNavBar(),

      // // 5. FAB (the green + button in Send Again row)
      // floatingActionButton: const _WalletFab(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ─── Teal Header Card ─────────────────────────────────────────────────────────

class WalletHeaderCard extends StatelessWidget {
  const WalletHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            padding: AppSpacing.paddingSymmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.addHeight(40),
                // Greeting row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good afternoon,',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Enjelin Morgeana',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    _NotificationBell(),
                  ],
                ),

                // const SizedBox(height: 28),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // width: double.infinity,
              margin: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),

              padding: AppSpacing.paddingSymmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 53, 142, 120),
                    Color.fromARGB(255, 36, 113, 94),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Balance
                  Row(
                    children: [
                      Text(
                        'Total Balance  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    '\$2,548.00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Income / Expenses row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _BalanceStat(
                        icon: Icons.arrow_upward,
                        iconColor: Colors.white,
                        label: 'Income',
                        amount: '\$ 1,840.00',
                      ),
                      // const SizedBox(width: 40),
                      _BalanceStat(
                        icon: Icons.arrow_downward,
                        iconColor: Colors.white,
                        label: 'Expenses',
                        amount: '\$ 284.00',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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

class _BalanceStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String amount;

  const _BalanceStat({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Transaction History ──────────────────────────────────────────────────────

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key});

  static const List<_TxData> _transactions = [
    _TxData(
      logo: _TxLogo.upwork,
      title: 'Upwork',
      subtitle: 'Today',
      amount: '+ \$ 850.00',
      isPositive: true,
    ),
    _TxData(
      logo: _TxLogo.transfer,
      title: 'Transfer',
      subtitle: 'Yesterday',
      amount: '- \$ 85.00',
      isPositive: false,
    ),
    _TxData(
      logo: _TxLogo.paypal,
      title: 'Paypal',
      subtitle: 'Jan 30, 2022',
      amount: '+ \$ 1,406.00',
      isPositive: true,
    ),
    _TxData(
      logo: _TxLogo.youtube,
      title: 'Youtube',
      subtitle: 'Jan 16, 2022',
      amount: '- \$ 11.99',
      isPositive: false,
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
              'Transactions History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            GestureDetector(
              onTap: () {},
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
        const SizedBox(height: 16),

        // Transaction rows
        ...List.generate(_transactions.length, (i) {
          final tx = _transactions[i];
          return Column(
            children: [
              _TransactionTile(data: tx),
              if (i < _transactions.length - 1)
                Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
            ],
          );
        }),
      ],
    );
  }
}

enum _TxLogo { upwork, transfer, paypal, youtube }

class _TxData {
  final _TxLogo logo;
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;

  const _TxData({
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });
}

class _TransactionTile extends StatelessWidget {
  final _TxData data;

  const _TransactionTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            data.amount,
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
        return _LogoContainer(
          color: const Color(0xFFE8F5E9),
          child: Text(
            'Up',
            style: TextStyle(
              color: const Color(0xFF14A800),
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        );
      case _TxLogo.transfer:
        return _LogoContainer(
          color: const Color(0xFFE3F2FD),
          child: const Icon(
            Icons.swap_horiz_rounded,
            color: Color(0xFF1565C0),
            size: 22,
          ),
        );
      case _TxLogo.paypal:
        return _LogoContainer(
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
        return _LogoContainer(
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

class _LogoContainer extends StatelessWidget {
  final Color color;
  final Widget child;

  const _LogoContainer({required this.color, required this.child});

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

// ─── Send Again Section ───────────────────────────────────────────────────────

class SendAgainSection extends StatelessWidget {
  const SendAgainSection({super.key});

  static const List<String> _initials = ['A', 'B', 'C', 'D', 'E'];
  static const List<Color> _colors = [
    Color(0xFFEF9A9A),
    Color(0xFF80DEEA),
    Color(0xFFA5D6A7),
    Color(0xFFFFCC80),
    Color(0xFFCE93D8),
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
              'Send Again',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            GestureDetector(
              onTap: () {},
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
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_initials.length, (i) {
            return _AvatarCircle(
              initial: _initials[i],
              backgroundColor: _colors[i],
            );
          }),
        ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String initial;
  final Color backgroundColor;

  const _AvatarCircle({required this.initial, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─── FAB ──────────────────────────────────────────────────────────────────────

class _WalletFab extends StatelessWidget {
  const _WalletFab();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: const Color(0xFF3DAA8E),
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

// ─── Bottom Nav Bar ───────────────────────────────────────────────────────────

class WalletBottomNavBar extends StatelessWidget {
  const WalletBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 12,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home (active)
            _NavItem(icon: Icons.home_rounded, isActive: true, onTap: () {}),
            // Stats
            _NavItem(
              icon: Icons.bar_chart_rounded,
              isActive: false,
              onTap: () {},
            ),
            // Spacer for FAB
            const SizedBox(width: 48),
            // Cards
            _NavItem(
              icon: Icons.credit_card_rounded,
              isActive: false,
              onTap: () {},
            ),
            // Profile
            _NavItem(
              icon: Icons.person_outline_rounded,
              isActive: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Icon(
          icon,
          size: 26,
          color: isActive ? const Color(0xFF3DAA8E) : Colors.grey.shade400,
        ),
      ),
    );
  }
}
