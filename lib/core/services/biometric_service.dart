// /// Biometric Service - Singleton Pattern Implementation
// /// Treats biometrics as a **key** to unlock securely stored credentials.
// /// - Uses `local_auth` for hardware biometric auth
// /// - Uses `flutter_secure_storage` for encrypted credential storage
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:local_auth/local_auth.dart';
//
// class BiometricService {
//   BiometricService._internal();
//
//   static BiometricService? _instance;
//   static BiometricService get instance {
//     _instance ??= BiometricService._internal();
//     return _instance!;
//   }
//
//   // Hardware biometric API
//   final LocalAuthentication _auth = LocalAuthentication();
//
//   // Encrypted storage (Keychain / Keystore)
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//
//   static const String _emailKey = 'bio_email';
//   static const String _passwordKey = 'bio_password';
//   static const String _faceIdEnabledKey = 'face_id_enabled';
//
//   /// Save credentials after the very first manual login
//   /// (or when the user enables biometric login in settings).
//   Future<void> saveCredentials(String email, String password) async {
//     await _secureStorage.write(key: _emailKey, value: email);
//     await _secureStorage.write(key: _passwordKey, value: password);
//
//   }
//
//   /// Clear stored credentials (e.g. on logout or when user disables biometrics).
//   Future<void> clearCredentials() async {
//     await _secureStorage.delete(key: _emailKey);
//     await _secureStorage.delete(key: _passwordKey);
//     await _secureStorage.delete(key: _faceIdEnabledKey);
//   }
//
//   /// Read stored credentials (without triggering biometrics).
//   Future<(String?, String?)> readCredentials() async {
//     final email = await _secureStorage.read(key: _emailKey);
//     final password = await _secureStorage.read(key: _passwordKey);
//     return (email, password);
//   }
//
//   /// Returns true if device both supports biometrics and has them set up.
//   Future<bool> canUseBiometrics() async {
//     try {
//       final canCheck = await _auth.canCheckBiometrics;
//       final supported = await _auth.isDeviceSupported();
//       return canCheck && supported;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   /// Show the system biometric prompt.
//   /// Returns true if the user successfully authenticates.
//   Future<bool> authenticate() async {
//     try {
//       return await _auth.authenticate(
//         localizedReason: 'Authenticate to login to your account',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           stickyAuth: true,
//         ),
//       );
//     } catch (_) {
//       return false;
//     }
//   }
//
//   ///update password of biometric log in
//   Future<void> updateBioPassword(String password) async {
//     await _secureStorage.write(key: _passwordKey, value: password);
//   }
//
//   ///update email of biometric log in
//   Future<void> updateBioEmail(String email) async {
//     await _secureStorage.write(key: _emailKey, value: email);
//   }
//
//   ///update email of biometric bool _faceIdEnabledKey
//   Future<void> updateFaceIdEnabled(String email) async {
//     await _secureStorage.write(key: _faceIdEnabledKey, value: email);
//   }
// }
//
/// Biometric Service - Singleton Pattern Implementation
/// Treats biometrics as a **key** to unlock securely stored credentials.
/// - Uses `local_auth` for hardware biometric auth
/// - Uses `flutter_secure_storage` for encrypted credential storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  BiometricService._internal();

  static BiometricService? _instance;
  static BiometricService get instance {
    _instance ??= BiometricService._internal();
    return _instance!;
  }

  // Hardware biometric API
  final LocalAuthentication _auth = LocalAuthentication();

  // Encrypted storage (Keychain / Keystore)
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _emailKey = 'bio_email';
  static const String _passwordKey = 'bio_password';
  static const String _faceIdEnabledKey = 'face_id_enabled';

  /// Save credentials after the very first manual login
  /// (or when the user enables biometric login in settings).
  Future<void> saveCredentials(String email, String password) async {
    await _secureStorage.write(key: _emailKey, value: email);
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  /// Clear stored credentials (e.g. on logout or when user disables biometrics).
  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _emailKey);
    await _secureStorage.delete(key: _passwordKey);
    await _secureStorage.delete(key: _faceIdEnabledKey);
  }

  /// Read stored credentials (without triggering biometrics).
  Future<(String?, String?)> readCredentials() async {
    final email = await _secureStorage.read(key: _emailKey);
    final password = await _secureStorage.read(key: _passwordKey);
    return (email, password);
  }

  /// Read stored credentials (without triggering biometrics).
  Future<(String?, String?)> readB() async {
    final email = await _secureStorage.read(key: _emailKey);
    final password = await _secureStorage.read(key: _passwordKey);
    return (email, password);
  }

  /// Returns true if device both supports biometrics and has them set up.
  Future<bool> canUseBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      return canCheck && supported;
    } catch (_) {
      return false;
    }
  }

  /// Show the system biometric prompt.
  /// Returns true if the user successfully authenticates.
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to login to your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  /// Update password stored for biometric login.
  Future<void> updateBioPassword(String password) async {
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  /// Update email stored for biometric login.
  Future<void> updateBioEmail(String email) async {
    await _secureStorage.write(key: _emailKey, value: email);
  }

  // ───────────────────────────────────────────────
  // Biometric Enable / Disable Flag
  // ───────────────────────────────────────────────

  /// Persist the biometric-enabled flag.
  /// Pass [true] to activate, [false] to deactivate.
  Future<void> setBiometricEnabled(bool isEnabled) async {
    await _secureStorage.write(
      key: _faceIdEnabledKey,
      value: isEnabled.toString(), // stored as 'true' / 'false'
    );
  }

  /// Read the biometric-enabled flag.
  /// Returns [false] if the flag has never been set.
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _faceIdEnabledKey);
    return value == 'true';
  }

  /// Enable biometrics and persist credentials in one atomic call.
  /// Typical use-case: user toggles biometric login ON in settings
  /// right after a successful manual login.
  Future<void> enableBiometric(String email, String password,bool isEnable) async {
    await saveCredentials(email, password);
    await setBiometricEnabled(isEnable);
  }

  /// Disable biometrics and wipe all stored credentials.
  /// Typical use-case: user toggles biometric login OFF or logs out.
  Future<void> disableBiometric() async {
    await setBiometricEnabled(false);
  }

  /// Full biometric login flow in one call:
  /// 1. Checks the enabled flag.
  /// 2. Triggers the hardware prompt.
  /// 3. Returns the stored credentials on success.
  ///
  /// Returns [null] if biometrics are disabled, the device doesn't
  /// support them, or the user fails authentication.
  Future<(String, String)?> loginWithBiometric() async {
    // Guard 1 – flag must be active
    final enabled = await isBiometricEnabled();
    if (!enabled) return null;

    // Guard 2 – hardware must be available
    final canUse = await canUseBiometrics();
    if (!canUse) return null;

    // Guard 3 – user must pass the prompt
    final authenticated = await authenticate();
    if (!authenticated) return null;

    // Return credentials only after all three guards pass
    final (email, password) = await readCredentials();
    if (email == null || password == null) return null;

    return (email, password);
  }
}