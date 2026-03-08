import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final bool showAddIcon;
  final VoidCallback? onAddPressed;
  final IconData? actionIcon;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.showAddIcon = false,
    this.onAddPressed,
    this.actionIcon,
    this.automaticallyImplyLeading = false,
    this.actions,
    this.leading,
    this.height = AppDimensions.appBarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final List<Widget> combinedActions = [
      if (actions != null) ...actions!,
      if (showAddIcon)
        IconButton(
          icon: Icon(actionIcon ?? Icons.add,),
          onPressed: onAddPressed,
        ),
    ];

    return AppBar(
      title:
      title != null
          ? AppText(
        txt: title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,

      )
          : null,
      leading: automaticallyImplyLeading
          ? Container()
          : IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onBackPressed ?? () => Get.back(),
      ),
      leadingWidth: automaticallyImplyLeading ? 16 : 40,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: combinedActions.isNotEmpty ? combinedActions : null,
      toolbarHeight: height,
    );
  }
}

