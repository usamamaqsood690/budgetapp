import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  State<InvestmentPage> createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  int _selectedTab = 0; // 0 = Portfolio, 1 = Watchlist

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4FAF8),
      child: SafeArea(
        child: Column(
          children: [
            // 1. Teal Header
            _InvestmentHeader(),

            // 2. Scrollable body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 3. Portfolio summary card
                    _PortfolioSummaryCard(),

                    Padding(
                      padding: AppSpacing.paddingSymmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        children: [
                          AppSpacing.addHeight(24),

                          // 4. Tab bar
                          _InvestmentTabBar(
                            selectedIndex: _selectedTab,
                            onTabChanged:
                                (i) => setState(() => _selectedTab = i),
                          ),
                          AppSpacing.addHeight(20),

                          // 5. Tab content
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child:
                                _selectedTab == 0
                                    ? const _PortfolioTab(
                                      key: ValueKey('portfolio'),
                                    )
                                    : const _WatchlistTab(
                                      key: ValueKey('watchlist'),
                                    ),
                          ),
                          AppSpacing.addHeight(24),
                        ],
                      ),
                    ),
                  ],
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

class _InvestmentHeader extends StatelessWidget {
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
              'Investments',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_outlined,
                size: 24,
                color: Colors.white,
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7043),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Portfolio Summary Card ───────────────────────────────────────────────────

class _PortfolioSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total portfolio value
          Text(
            'Total Portfolio Value',
            style: TextStyle(
              color: Colors.white.withOpacity(0.80),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          AppSpacing.addHeight(6),
          const Text(
            '\$ 24,582.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          AppSpacing.addHeight(8),

          // Gain pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  '+\$1,240.00  (+5.32%)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.addHeight(24),

          // Stats row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryStat(label: 'Invested', value: '\$23,342'),
                _StatDivider(),
                _SummaryStat(label: 'Returns', value: '+\$1,240'),
                _StatDivider(),
                _SummaryStat(label: 'Assets', value: '6'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white.withOpacity(0.25),
    );
  }
}

// ─── Tab Bar ──────────────────────────────────────────────────────────────────

class _InvestmentTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _InvestmentTabBar({
    required this.selectedIndex,
    required this.onTabChanged,
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
        children: [
          _TabItem(
            label: 'Portfolio',
            isActive: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            label: 'Watchlist',
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? const Color(0xFF1A1A2E) : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Portfolio Tab ────────────────────────────────────────────────────────────

class _PortfolioTab extends StatelessWidget {
  const _PortfolioTab({super.key});

  static const List<_AssetData> _assets = [
    _AssetData(
      logo: _AssetLogo.apple,
      name: 'Apple Inc.',
      ticker: 'AAPL',
      shares: '5 shares',
      value: '\$942.50',
      change: '+2.34%',
      isPositive: true,
    ),
    _AssetData(
      logo: _AssetLogo.bitcoin,
      name: 'Bitcoin',
      ticker: 'BTC',
      shares: '0.12 BTC',
      value: '\$5,184.00',
      change: '+4.12%',
      isPositive: true,
    ),
    _AssetData(
      logo: _AssetLogo.tesla,
      name: 'Tesla',
      ticker: 'TSLA',
      shares: '3 shares',
      value: '\$732.60',
      change: '-1.08%',
      isPositive: false,
    ),
    _AssetData(
      logo: _AssetLogo.ethereum,
      name: 'Ethereum',
      ticker: 'ETH',
      shares: '2.5 ETH',
      value: '\$4,312.00',
      change: '+3.67%',
      isPositive: true,
    ),
    _AssetData(
      logo: _AssetLogo.amazon,
      name: 'Amazon',
      ticker: 'AMZN',
      shares: '2 shares',
      value: '\$6,284.00',
      change: '-0.55%',
      isPositive: false,
    ),
    _AssetData(
      logo: _AssetLogo.google,
      name: 'Alphabet',
      ticker: 'GOOGL',
      shares: '4 shares',
      value: '\$7,127.00',
      change: '+1.22%',
      isPositive: true,
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
              'My Assets',
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
        AppSpacing.addHeight(14),

        // Asset list
        ...List.generate(_assets.length, (i) {
          final asset = _assets[i];
          return Column(
            children: [
              _AssetTile(data: asset),
              if (i < _assets.length - 1)
                Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
            ],
          );
        }),
      ],
    );
  }
}

// ─── Watchlist Tab ────────────────────────────────────────────────────────────

class _WatchlistTab extends StatelessWidget {
  const _WatchlistTab({super.key});

  static const List<_AssetData> _watchlist = [
    _AssetData(
      logo: _AssetLogo.microsoft,
      name: 'Microsoft',
      ticker: 'MSFT',
      shares: '\$415.20',
      value: '\$415.20',
      change: '+1.45%',
      isPositive: true,
    ),
    _AssetData(
      logo: _AssetLogo.solana,
      name: 'Solana',
      ticker: 'SOL',
      shares: '\$142.80',
      value: '\$142.80',
      change: '+6.30%',
      isPositive: true,
    ),
    _AssetData(
      logo: _AssetLogo.meta,
      name: 'Meta',
      ticker: 'META',
      shares: '\$502.30',
      value: '\$502.30',
      change: '-2.10%',
      isPositive: false,
    ),
    _AssetData(
      logo: _AssetLogo.netflix,
      name: 'Netflix',
      ticker: 'NFLX',
      shares: '\$628.50',
      value: '\$628.50',
      change: '+0.88%',
      isPositive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Watchlist',
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
        AppSpacing.addHeight(14),

        ...List.generate(_watchlist.length, (i) {
          final asset = _watchlist[i];
          return Column(
            children: [
              _AssetTile(data: asset, isWatchlist: true),
              if (i < _watchlist.length - 1)
                Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
            ],
          );
        }),
      ],
    );
  }
}

// ─── Asset Tile ───────────────────────────────────────────────────────────────

class _AssetTile extends StatelessWidget {
  final _AssetData data;
  final bool isWatchlist;

  const _AssetTile({required this.data, this.isWatchlist = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          // Logo
          _AssetLogoWidget(logo: data.logo),
          const SizedBox(width: 14),

          // Name + ticker/shares
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isWatchlist ? data.ticker : data.shares,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Value + change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      data.isPositive
                          ? const Color(0xFFE8F7F3)
                          : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.change,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color:
                        data.isPositive
                            ? const Color(0xFF3DAA8E)
                            : const Color(0xFFE53935),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Asset Logo Widget ────────────────────────────────────────────────────────

enum _AssetLogo {
  apple,
  bitcoin,
  tesla,
  ethereum,
  amazon,
  google,
  microsoft,
  solana,
  meta,
  netflix,
}

class _AssetLogoWidget extends StatelessWidget {
  final _AssetLogo logo;
  const _AssetLogoWidget({required this.logo});

  @override
  Widget build(BuildContext context) {
    switch (logo) {
      case _AssetLogo.apple:
        return _LogoBox(
          bg: const Color(0xFFF5F5F5),
          child: const Icon(Icons.apple, color: Color(0xFF1A1A2E), size: 24),
        );
      case _AssetLogo.bitcoin:
        return _LogoBox(
          bg: const Color(0xFFFFF3E0),
          child: const Text(
            '₿',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF7931A),
            ),
          ),
        );
      case _AssetLogo.tesla:
        return _LogoBox(
          bg: const Color(0xFFFFEBEE),
          child: const Text(
            'T',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFFCC0000),
            ),
          ),
        );
      case _AssetLogo.ethereum:
        return _LogoBox(
          bg: const Color(0xFFEDE7F6),
          child: const Text(
            'Ξ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5C35C9),
            ),
          ),
        );
      case _AssetLogo.amazon:
        return _LogoBox(
          bg: const Color(0xFFFFF8E1),
          child: const Text(
            'A',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFF9900),
            ),
          ),
        );
      case _AssetLogo.google:
        return _LogoBox(
          bg: const Color(0xFFE3F2FD),
          child: const Text(
            'G',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4285F4),
            ),
          ),
        );
      case _AssetLogo.microsoft:
        return _LogoBox(
          bg: const Color(0xFFE3F2FD),
          child: const Text(
            'M',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0078D4),
            ),
          ),
        );
      case _AssetLogo.solana:
        return _LogoBox(
          bg: const Color(0xFFE8F7F3),
          child: const Text(
            '◎',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9945FF),
            ),
          ),
        );
      case _AssetLogo.meta:
        return _LogoBox(
          bg: const Color(0xFFE8EAF6),
          child: const Text(
            'f',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: Color(0xFF1877F2),
            ),
          ),
        );
      case _AssetLogo.netflix:
        return _LogoBox(
          bg: const Color(0xFFFFEBEE),
          child: const Text(
            'N',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE50914),
            ),
          ),
        );
    }
  }
}

class _LogoBox extends StatelessWidget {
  final Color bg;
  final Widget child;
  const _LogoBox({required this.bg, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ─── Data Models ──────────────────────────────────────────────────────────────

class _AssetData {
  final _AssetLogo logo;
  final String name;
  final String ticker;
  final String shares;
  final String value;
  final String change;
  final bool isPositive;

  const _AssetData({
    required this.logo,
    required this.name,
    required this.ticker,
    required this.shares,
    required this.value,
    required this.change,
    required this.isPositive,
  });
}
