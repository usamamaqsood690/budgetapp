import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/data/network/network_info_impl.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';

/// Internet Connection Service
class InternetConnectionService {
  InternetConnectionService._internal();

  static final InternetConnectionService _instance =
      InternetConnectionService._internal();

  /// Global singleton instance
  static InternetConnectionService get instance => _instance;

  final NetworkInfoImpl _networkInfo = NetworkInfoImpl.instance;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  List<ConnectivityResult>? _lastResults;
  bool _isListening = false;
  bool _hasSeenFirstEvent = false;
  bool _isOfflineBannerVisible = false;

  /// Start listening for connectivity changes (idempotent).
  ///
  /// Call this once when the app starts (e.g. in `MyApp.build`).
  void startListening() {
    if (_isListening) return;
    _isListening = true;

    // Fire an initial check so we know the starting state.
    _checkInitialStatus();

    _subscription ??= _networkInfo.onConnectivityChanged
        // Avoid duplicate events with same content
        .distinct(listEquals)
        .listen(_handleConnectivityChange);
  }

  /// Stop listening. Normally you don't need to call this because the
  /// service lives for the duration of the app.
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _isListening = false;
  }

  Future<void> _checkInitialStatus() async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        _showNoInternetBanner();
      }
    } catch (_) {
      // Swallow errors here – we don't want to crash the app on startup
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection = _hasConnection(results);
    final hadConnection = _hasConnection(_lastResults);

    // First event after starting listener: treat as initial state, not "back online"
    if (!_hasSeenFirstEvent) {
      _hasSeenFirstEvent = true;

      // If the very first state is offline, show offline banner
      if (!hasConnection) {
        _showNoInternetBanner();
      }

      _lastResults = List<ConnectivityResult>.from(results);
      return;
    }

    // No internet
    if (!hasConnection) {
      _showNoInternetBanner();
    }
    // Back online
    else if (!hadConnection && hasConnection) {
      _showBackOnlineBanner();
    }

    _lastResults = List<ConnectivityResult>.from(results);
  }

  bool _hasConnection(List<ConnectivityResult>? results) {
    if (results == null || results.isEmpty) return false;
    return !results.contains(ConnectivityResult.none);
  }

  void _showNoInternetBanner() {
    // Keep a single, persistent banner while offline
    if (_isOfflineBannerVisible) return;
    _isOfflineBannerVisible = true;

    final context = Get.context;
    if (context == null) return;
    AppSnackBar.showError(
      'Please check your network settings.',
      duration: const Duration(days: 365),
      position: SnackPosition.TOP,
      title: 'No internet connection',
      isDismissible: false,
      icon: const Icon(Icons.wifi_off),
    );
  }

  void _hideOfflineBanner() {
    if (!_isOfflineBannerVisible) return;
    _isOfflineBannerVisible = false;
    Get.closeAllSnackbars();
  }

  void _showBackOnlineBanner() {
    // When back online, hide the persistent offline banner and show a short info banner
    _hideOfflineBanner();

    final context = Get.context;
    if (context == null) return;

    AppSnackBar.showInfo(
        'Your internet connection has been restored.',
      duration: const Duration(seconds: 3),
      position: SnackPosition.TOP,
      title: 'Back online',
      isDismissible: true,
      icon: const Icon(Icons.wifi),
    );
  }

}
