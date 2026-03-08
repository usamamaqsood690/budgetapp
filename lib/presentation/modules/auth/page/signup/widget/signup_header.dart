import 'package:flutter/foundation.dart'; // Required for kDebugMode
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/envirnment/envirnment_config.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: AppText(
                txt: "Create account".tr,
                textAlign: TextAlign.start,
                style: context.headlineLarge,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: AppDimensions.borderRadiusSM,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Environment>(
                    value: EnvironmentConfig.current,
                    isExpanded: true,
                    iconSize: 0.0,
                    icon: const SizedBox.shrink(),
                    selectedItemBuilder: (context) {
                      return Environment.values.map((env) {
                        return SizedBox();
                      }).toList();
                    },
                    items: Environment.values.map((env) {
                      return DropdownMenuItem<Environment>(
                        value: env,
                        child: AppText(
                          txt: EnvironmentConfig.getEnvironmentDisplayName(
                            env,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        EnvironmentConfig.setEnvironment(value);
                        // Update API client base URL immediately
                        ApiClient.instance.updateBaseUrl();
                        debugPrint(
                          "ENV changed to: ${value.name}",
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        AppSpacing.addHeight(AppSpacing.sm),
        AppText(
          txt: "Fill the information below to create an account...".tr,
          textAlign: TextAlign.start,
          style: context.bodyMedium,
        ),
      ],
    );
  }
}
