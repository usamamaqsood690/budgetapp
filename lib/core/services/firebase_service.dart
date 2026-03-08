/// Firebase Service - Singleton Pattern Implementation
/// Handles Firebase Cloud Messaging (FCM) token operations
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance {
    _instance ??= FirebaseService._internal();
    return _instance!;
  }

  FirebaseService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _cachedToken;

  /// Initialize Firebase Messaging and request permissions
  Future<void> initialize() async {
    try {
      // Request notification permissions
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        await getFCMToken();
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        await getFCMToken();
      }
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }

  /// Get the current FCM token
  /// Returns cached token if available, otherwise fetches a new one
  Future<String?> getFCMToken() async {
    try {
      if (_cachedToken != null) {
        return _cachedToken;
      }

      _cachedToken = await _firebaseMessaging.getToken();
      return _cachedToken;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  /// Refresh the FCM token
  /// Useful when token needs to be updated
  Future<String?> refreshFCMToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _cachedToken = await _firebaseMessaging.getToken();
      return _cachedToken;
    } catch (e) {
      print('Error refreshing FCM token: $e');
      return null;
    }
  }

  /// Clear the cached token
  void clearCachedToken() {
    _cachedToken = null;
  }

  /// Listen to token refresh events
  Stream<String?> onTokenRefresh() {
    return _firebaseMessaging.onTokenRefresh;
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      print('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      print('Error unsubscribing from topic $topic: $e');
    }
  }

  /// Delete the FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _cachedToken = null;
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}
