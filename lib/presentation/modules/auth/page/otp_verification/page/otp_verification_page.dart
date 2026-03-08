/// OTP Verification Screen - Presentation Layer
/// OTP verification page for signup, forgot password, etc.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/themes/app_text_theme.dart';
import 'package:wealthnxai/presentation/modules/auth/page/otp_verification/controller/otp_verification_page_controller.dart';
import 'package:wealthnxai/presentation/modules/auth/page/otp_verification/widget/otp_pin_widget.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final controller = Get.find<OtpVerificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(),
      body: Padding(
        padding:AppSpacing.paddingSymmetric(horizontal: AppSpacing.xxl),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.addHeight(AppSpacing.sm),
              AppText(
                txt: "Enter authentication code".tr,
                textAlign: TextAlign.center,
                style: context.bodyLarge,
              ),
              AppSpacing.addHeight(AppSpacing.sm),

              RichText(
                text: TextSpan(
                  text:
                      'Enter the 4-digit code that we have sent via the\nEmail ',
                  style: TextStyle(
                    fontSize: AppTextTheme.fontSize10,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: controller.email ?? '',
                      style: TextStyle(
                        fontWeight: AppTextTheme.weightBold,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.addHeight(AppSpacing.lg),
              Center(
                child: AppOtpField(
                  controller: controller.otpController,
                ),
              ),
              AppSpacing.addHeight(AppSpacing.sm),
              AppButton(
                onTap: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.verifyOtp();
                  }
                },
                txt: 'Continue'.tr,
              ),
              AppSpacing.addHeight(AppSpacing.lg),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                                controller.resendOtp();
                              },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                      ),
                      child:  AppText(
                        txt: "Resend Code".tr,
                        style: context.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
