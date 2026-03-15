import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/notification/binding/notification_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/notification/page/notification_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const List<_MenuItemData> _menuItems = [
    _MenuItemData(
      icon: Icons.diamond_outlined,
      label: 'Invite Friends',
      iconColor: Color(0xFF3DAA8E),
      iconBg: Color(0xFFE8F7F3),
    ),
    _MenuItemData(
      icon: Icons.person_outline_rounded,
      label: 'Account info',
      iconColor: Color(0xFF1A1A2E),
      iconBg: Color(0xFFF0F0F0),
    ),
    _MenuItemData(
      icon: Icons.people_outline_rounded,
      label: 'Personal profile',
      iconColor: Color(0xFF1A1A2E),
      iconBg: Color(0xFFF0F0F0),
    ),
    _MenuItemData(
      icon: Icons.mail_outline_rounded,
      label: 'Message center',
      iconColor: Color(0xFF1A1A2E),
      iconBg: Color(0xFFF0F0F0),
    ),
    _MenuItemData(
      icon: Icons.shield_outlined,
      label: 'Login and security',
      iconColor: Color(0xFF1A1A2E),
      iconBg: Color(0xFFF0F0F0),
    ),
    _MenuItemData(
      icon: Icons.lock_outline_rounded,
      label: 'Data and privacy',
      iconColor: Color(0xFF1A1A2E),
      iconBg: Color(0xFFF0F0F0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. Teal Header with avatar
          _ProfileHeader(),

          // 2. Menu list
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  AppSpacing.addHeight(80), // Space for avatar overlap
                  ...List.generate(_menuItems.length, (i) {
                    final item = _menuItems[i];
                    return Column(
                      children: [
                        _MenuItem(data: item),
                        if (i < _menuItems.length - 1)
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            color: Colors.grey.shade200,
                          ),
                      ],
                    );
                  }),
                  AppSpacing.addHeight(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
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
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(400, 50),
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
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => NotificationPage(),
                        binding: NotificationBinding(),
                      );
                    },
                    child: _NotificationBell(),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Avatar + name card — overlaps header and white body
        Positioned(
          bottom: -80,
          child: Column(
            children: [
              // Avatar circle
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(child: _AvatarPlaceholder()),
              ),
              const SizedBox(height: 10),

              // Name
              const Text(
                'Enjelin Morgeana',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 0),

              // Username
              const Text(
                '@enjelin_morgeana',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3DAA8E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Avatar Placeholder ───────────────────────────────────────────────────────

class _AvatarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Illustrated avatar using gradient + icon
    return Container(
      color: const Color(0xFFE8F7F3),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Body
          Positioned(
            bottom: -6,
            child: Container(
              width: 56,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF8D6E63),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          // Head
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFA1887F),
              shape: BoxShape.circle,
            ),
          ),
          // Hair
          Positioned(
            top: 10,
            child: Container(
              width: 44,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF4E342E),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Menu Item ────────────────────────────────────────────────────────────────

class _MenuItemData {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBg;

  const _MenuItemData({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBg,
  });
}

class _MenuItem extends StatelessWidget {
  final _MenuItemData data;

  const _MenuItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: data.iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(data.icon, size: 22, color: data.iconColor),
            ),
            const SizedBox(width: 16),

            // Label
            Expanded(
              child: Text(
                data.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Colors.grey.shade400,
            ),
          ],
        ),
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
