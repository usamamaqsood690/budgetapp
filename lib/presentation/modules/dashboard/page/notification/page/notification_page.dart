import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/my_widgets/custom_appbar/custom_appbar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Track read/unread state per notification
  final List<bool> _readState = List.generate(
    _NotificationData.items.length,
    (i) => _NotificationData.items[i].isRead,
  );

  void _markAllRead() =>
      setState(() => _readState.fillRange(0, _readState.length, true));

  void _markRead(int index) => setState(() => _readState[index] = true);

  @override
  Widget build(BuildContext context) {
    final unreadCount = _readState.where((r) => !r).length;

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
            CustomAppbarWithBack(title: 'Notifications'),
            // _NotificationsHeader(
            //   unreadCount: unreadCount,
            //   onMarkAllRead: _markAllRead,
            // ),

            // 2. List
            Expanded(
              child:
                  _readState.every((r) => r) && _NotificationData.items.isEmpty
                      ? const _EmptyState()
                      : Container(
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
                            vertical: AppSpacing.sm,
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 0),
                            itemCount: _NotificationData.items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return AppSpacing.addHeight(16);
                              }
                              final i = index - 1;
                              final item = _NotificationData.items[i];
                              final isRead = _readState[i];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _NotificationTile(
                                  data: item,
                                  isRead: isRead,
                                  onTap: () => _markRead(i),
                                ),
                              );
                            },
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

// ─── Notification Tile ────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final _NotificationItem data;
  final bool isRead;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.data,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFE8F7F3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isRead
                    ? Colors.transparent
                    : const Color(0xFF3DAA8E).withOpacity(0.2),
            width: 1,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon box
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isRead ? data.iconBg.withOpacity(0.6) : data.iconBg,
                borderRadius: BorderRadius.circular(13),
              ),
              alignment: Alignment.center,
              child: Icon(data.icon, size: 22, color: data.iconColor),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isRead ? FontWeight.w500 : FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      // Unread dot
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3DAA8E),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.time,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color:
                          isRead
                              ? Colors.grey.shade400
                              : const Color(0xFF3DAA8E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F7F3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 38,
              color: Color(0xFF3DAA8E),
            ),
          ),
          AppSpacing.addHeight(16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          AppSpacing.addHeight(6),
          Text(
            "You're all caught up!",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ─── Data Model ───────────────────────────────────────────────────────────────

class _NotificationItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  const _NotificationItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
  });
}

class _NotificationData {
  static const List<_NotificationItem> items = [
    _NotificationItem(
      icon: Icons.arrow_circle_down_rounded,
      iconBg: Color(0xFFE8F7F3),
      iconColor: Color(0xFF3DAA8E),
      title: 'Payment Received',
      subtitle: 'You received \$850.00 from Upwork Escrow.',
      time: 'Just now',
      isRead: false,
    ),
    _NotificationItem(
      icon: Icons.receipt_long_rounded,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFE53935),
      title: 'Bill Due Soon',
      subtitle: 'Your Youtube Premium bill of \$11.99 is due on Feb 28, 2022.',
      time: '2 hours ago',
      isRead: false,
    ),
    _NotificationItem(
      icon: Icons.check_circle_outline_rounded,
      iconBg: Color(0xFFE8F7F3),
      iconColor: Color(0xFF3DAA8E),
      title: 'Payment Successful',
      subtitle: 'Your payment of \$13.98 to Youtube Premium was completed.',
      time: '5 hours ago',
      isRead: false,
    ),
    _NotificationItem(
      icon: Icons.swap_horiz_rounded,
      iconBg: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1565C0),
      title: 'Transfer Sent',
      subtitle: '\$85.00 was transferred from your wallet successfully.',
      time: 'Yesterday',
      isRead: true,
    ),
    _NotificationItem(
      icon: Icons.account_balance_rounded,
      iconBg: Color(0xFFE8F7F3),
      iconColor: Color(0xFF3DAA8E),
      title: 'Bank Account Linked',
      subtitle:
          'Your bank account has been successfully connected via Bank Link.',
      time: 'Yesterday',
      isRead: true,
    ),
    _NotificationItem(
      icon: Icons.credit_card_rounded,
      iconBg: Color(0xFFF3E5F5),
      iconColor: Color(0xFF7B1FA2),
      title: 'Debit Card Added',
      subtitle:
          'Your Mono debit card ending in 8075 has been added to your wallet.',
      time: '2 days ago',
      isRead: true,
    ),
    _NotificationItem(
      icon: Icons.shield_outlined,
      iconBg: Color(0xFFFFF9C4),
      iconColor: Color(0xFFF9A825),
      title: 'Security Alert',
      subtitle:
          'A new login was detected on your account. If this was not you, please secure your account.',
      time: '3 days ago',
      isRead: true,
    ),
    _NotificationItem(
      icon: Icons.local_offer_rounded,
      iconBg: Color(0xFFE8F5E9),
      iconColor: Color(0xFF2E7D32),
      title: 'Special Offer',
      subtitle:
          'Invite friends and earn \$10 cashback for every successful referral.',
      time: '5 days ago',
      isRead: true,
    ),
  ];
}
