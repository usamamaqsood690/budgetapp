import 'package:flutter/services.dart';

/// App Configuration Service
/// Manages app-wide configuration settings like orientation and system preferences
class AppConfigService {
  AppConfigService._();

  /// Call this in main() before runApp()
  static Future<void> initialize() async {
    // Lock app to portrait orientation only
    await lockToPortrait();
  }

  /// Lock app to portrait orientation only
  static Future<void> lockToPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Lock app to landscape orientation only
  static Future<void> lockToLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Allow all orientations
  static Future<void> allowAllOrientations() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Reset to system default orientations
  static Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations([]);
  }

  /// Enable system UI overlays (status bar, navigation bar)
  static void enableSystemUIOverlays() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Set status bar style
  static void setStatusBarStyle({required SystemUiOverlayStyle style}) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
