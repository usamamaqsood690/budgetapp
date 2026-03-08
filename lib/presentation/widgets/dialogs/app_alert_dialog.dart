import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// App Alert Dialog Helper
class AppAlertDialog {
  AppAlertDialog._();

  /// Show alert dialog with theme-aware styling
  static void show({
    required DialogType dialogType,
    required String title,
    String? description,
    String? btnCancelText,
    String? btnOkText,
    Color? btnOkColor,
    bool reverseBtnOrder = false,
    Color? btnCancelColor,
    VoidCallback? onCancelPress,
    VoidCallback? onOkPress,
    Function(DismissType dismissType)? onDismissCallBack,
    bool autoDismiss = true,
    bool dismissOnTouchOutside = true,
    bool dismissOnBackKeyPress = true,
  }) {
    final context = Get.context;
    if (context == null) return;

    final theme = Theme.of(context);
    final defaultOkColor = btnOkColor ?? theme.colorScheme.primary;
    final defaultCancelColor = btnCancelColor ?? theme.colorScheme.secondary;

    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dialogType: dialogType,
      width: 400,
      reverseBtnOrder: reverseBtnOrder,
      animType: AnimType.bottomSlide,
      title: title,
      btnOkColor: defaultOkColor,
      btnCancelColor: defaultCancelColor,
      onDismissCallback: onDismissCallBack,
      autoDismiss: autoDismiss,
      desc: description ?? "",
      btnCancelText: btnCancelText ?? "dismiss".tr,
      btnOkText: btnOkText,
      btnCancelOnPress: onCancelPress ?? () {},
      btnOkOnPress: onOkPress,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
    ).show();
  }

  /// Show success dialog
  static void showSuccess({
    required String title,
    String? description,
    VoidCallback? onOkPress,
  }) {
    show(
      dialogType: DialogType.success,
      title: title,
      description: description,
      btnOkText: 'ok'.tr,
      onOkPress: onOkPress,
    );
  }

  /// Show error dialog
  static void showError({
    required String title,
    String? description,
    VoidCallback? onOkPress,
  }) {
    show(
      dialogType: DialogType.error,
      title: title,
      description: description,
      btnOkText: 'ok'.tr,
      onOkPress: onOkPress,
    );
  }

  /// Show warning dialog
  static void showWarning({
    required String title,
    String? description,
    VoidCallback? onOkPress,
  }) {
    show(
      dialogType: DialogType.warning,
      title: title,
      description: description,
      btnOkText: 'ok'.tr,
      onOkPress: onOkPress,
    );
  }

  /// Show info dialog
  static void showInfo({
    required String title,
    String? description,
    VoidCallback? onOkPress,
  }) {
    show(
      dialogType: DialogType.info,
      title: title,
      description: description,
      btnOkText: 'ok'.tr,
      onOkPress: onOkPress,
    );
  }

  /// Show confirmation dialog
  static void showConfirmation({
    required String title,
    String? description,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? confirmText,
    String? cancelText,
  }) {
    show(
      dialogType: DialogType.question,
      title: title,
      description: description,
      btnOkText: confirmText ?? 'confirm'.tr,
      btnCancelText: cancelText ?? 'cancel'.tr,
      onOkPress: onConfirm,
      onCancelPress: onCancel,
    );
  }
}
