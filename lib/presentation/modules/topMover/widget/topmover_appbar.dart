import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class TopMoverAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? symbol;
  final String? imageUrl;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final double height;

  const TopMoverAppBar({
    super.key,
    this.title,
    this.symbol,
    this.imageUrl,
    this.onBackPressed,
    this.actions,
    this.automaticallyImplyLeading = false,
    this.height = AppDimensions.appBarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: automaticallyImplyLeading
          ? Container()
          : IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onBackPressed ?? () => Get.back(),
      ),
      leadingWidth: automaticallyImplyLeading ? 16 : 40,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Row(
        children: [
          if (imageUrl != null) ...[
            AppImageAvatar(
              avatarUrl: imageUrl,
              radius: 14,
              fallbackAsset: 'assets/icons/coin_placeholder.png',
              borderWidth: 0,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: AppText(
              txt: title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (symbol != null)
            AppText(
              txt: ' (${symbol!.toUpperCase()})',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
        ],
      ),
      actions: actions,
      toolbarHeight: height,
    );
  }
}