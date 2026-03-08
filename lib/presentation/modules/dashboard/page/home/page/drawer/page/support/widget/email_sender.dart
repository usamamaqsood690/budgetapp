import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';

class EmailSender {
  const EmailSender._();

  /// Open the default email app to contact support.
  static Future<void> openSupportEmail(BuildContext context) async {
    const String email = 'support@wealthnx.ai';
    const String subject = '';
    const String body = '';

    final Uri emailUri = Uri.parse('mailto:$email?subject=$subject&body=$body');

    try {
      final bool canLaunch = await canLaunchUrl(emailUri);

      if (canLaunch) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
       AppSnackBar.showError(
          'Cannot open email app',
          title: 'Email Failed',
        );
      }
    } catch (_) {
      AppSnackBar.showError(
        'Failed to open email app',
        title: 'Email Failed',
      );
    }
  }
}
