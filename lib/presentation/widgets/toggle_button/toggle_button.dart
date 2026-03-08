// lib/presentation/widgets/toggle_button/demo_real_toggle.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/presentation/widgets/dialogs/connectivity_dialogue.dart';
import 'package:wealthnxai/presentation/widgets/toggle_button/toggle_btn_controller.dart';

class ConnectAccountToggle extends StatelessWidget {
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double borderWidth;

  ConnectAccountToggle({
    super.key,
    this.fontSize = 12.0,
    this.horizontalPadding = 15.0,
    this.verticalPadding = 4.0,
    this.borderRadius = 30.0,
    this.borderWidth = 0.5,
  });

  final ToggleBtnController _controller = Get.put(ToggleBtnController());
  // final CheckPlaidConnectionController _connectivityController =
  // Get.find<CheckPlaidConnectionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colorScheme.primary,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleItem(
            context: context,
            title: 'Demo',
            isSelected: _controller.isDemo.value,
            onTap: () => _controller.toggle(true),
          ),
          const SizedBox(width: 5),
          _buildToggleItem(
            context: context,
            title: 'Connect Account',
            isSelected: !_controller.isDemo.value,
            onTap: _showConnectivityDialog,
          ),
        ],
      ),
    ));
  }

  Widget _buildToggleItem({
    required BuildContext context,
    required String title,
    required bool isSelected,
     VoidCallback ? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary
              : context.colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Future<void> _onConnectAccountTap() async {
  //   // Check internet connection
  //   bool hasInternet = await _connectivityController.hasInternetConnection();
  //
  //   if (!hasInternet) {
  //     _showNoInternetSnackbar();
  //     return;
  //   }
  //
  //   // Refresh connection status
  //   await _connectivityController.checkConnection();
  //
  //   // Check Plaid connection
  //   if (_connectivityController.isConnected.value == false ||
  //       _connectivityController.isConnected.value == null) {
  //     _showConnectivityDialog();
  //     _controller.toggle(false);
  //   } else {
  //     _controller.toggle(false);
  //   }
  // }

  void _showNoInternetSnackbar() {
    Get.snackbar(
      'No Internet Connection',
      'Please check your internet and try again',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
    );
  }

  void _showConnectivityDialog() {
    Get.dialog(
      barrierColor: Colors.black.withOpacity(0.85),
      ConnectivityDialog(
        onPressed: () {
          Get.back();
          _controller.toggle(true);
        },
      ),
    );
  }
}