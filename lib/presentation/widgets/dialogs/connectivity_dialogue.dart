import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class ConnectivityDialog extends StatelessWidget {
  ConnectivityDialog({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 26),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(23),
            boxShadow: [
              BoxShadow(
                color: const Color(0x14FFFFFF),
                blurRadius: 6.73,
                offset: const Offset(0, 0),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: const Color(0x33787878),
                blurRadius: 31.61,
                offset: const Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
            //  border: Border.all(color: context.gc(AppColor.grey), width: 0.25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: onPressed ?? () => Get.back(),
                  child: Icon(Icons.close, color: context.colors.grey,size: 25,),
                ),
              ),
              Image.asset(ImagePaths.merge, fit: BoxFit.contain, height: 56),
              AppSpacing.addHeight(40),
              AppText(
                txt: "WealthNX uses Plaid to connect".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              AppText(
                txt: "With your accounts".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              AppSpacing.addHeight(16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: AppText(
                  txt:
                      "Connect account to get the complete personal finance experience"
                          .tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              AppSpacing.addHeight(20),
              AppButton(
                txt: 'Connect Account',
                onTap: () async {
                  //   Get.to(() => ConnectAccounts());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
