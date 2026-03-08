import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';

import '../controller/wealth_genie_controller.dart';

/// Basic placeholder Wealth Genie page
class WealthGeniePage extends StatelessWidget {
  const WealthGeniePage({super.key});

  @override
  Widget build(BuildContext context) {
    final WealthGenieController controller = Get.find<WealthGenieController>();

    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.isProcessing.value
              ? const CircularProgressIndicator()
              : Text(
                  'Wealth Genie module coming soon',
                ),
        ),
      ),
    );
  }
}

