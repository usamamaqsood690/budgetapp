import 'package:get/get.dart';

/// Validators
/// Provides validation functions for form inputs
class Validators {
  Validators._();

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required'.tr;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Must be a valid email format'.tr;
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required'.tr;
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters'.tr;
    }
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required'.tr;
    }
    return null;
  }

  /// Validate name (letters and spaces only, min 2 characters)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required (cannot be empty)'.tr;
    }
    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
      return 'Should contain only letters (no numbers or symbols)'.tr;
    }
    if (value.trim().length < 2) {
      return 'Minimum 2 characters required'.tr;
    }
    return null;
  }

  /// Validate password with strong requirements
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required'.tr;
    }
    if (value.length < 8) {
      return 'Must be at least 8 characters long'.tr;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must have at least one uppercase letter (A-Z)'.tr;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must have at least one lowercase letter (a-z)'.tr;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must have at least one number (0-9)'.tr;
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Must have at least one special symbol (@, #, \$, !, etc.)'.tr;
    }
    return null;
  }

  /// Validate confirm password matches new password
  static String? validateConfirmPassword(String? value, String newPassword) {
    if (value == null || value.isEmpty) {
      return 'Required'.tr;
    }
    if (value != newPassword) {
      return 'Password Not Match'.tr;
    }
    return null;
  }

  /// Validate pin with strong requirements
  static String? validateStrongPin(String? value) {
    (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the OTP';
      }
      if (value.length < 4) {
        return 'OTP must be 4 digits';
      }
    };
    return null;
  }

  /// Validate date and time
  static String? validateDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select date'.tr;
    }
    return null;
  }
}
