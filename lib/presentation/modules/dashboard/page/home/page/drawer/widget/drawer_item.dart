import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

Widget drawerItem(
    BuildContext context, {
      required String iconImage,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) {
  return ListTile(
    splashColor: context.colors.transparent,
    hoverColor: context.colors.transparent,
    focusColor: context.colors.transparent,
    tileColor: context.colors.transparent,
    onTap: onTap,
    contentPadding:AppSpacing.marginZero(),
    leading:  AppImageAvatar(
      isCircular: false,
      radius: AppDimensions.iconLG,
      fallbackAsset:iconImage,
    ),
    title: AppText(txt: title),
    subtitle:subtitle.isEmpty? null : AppText(txt: subtitle),
  );
}
