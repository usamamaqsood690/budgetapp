import 'dart:convert';

import 'package:wealthnxai/core/services/storage_service.dart';

class FeedbackDialogService {

  final StorageService _storageService = StorageService.instance;
  /// Check if feedback dialog has been shown for a specific user
  Future<bool> hasShownFeedbackDialog(String userId) async {
    final String? storedData = await _storageService.getFeedBack();

    if (storedData == null) {
      return false;
    }

    try {
      Map<String, dynamic> userFeedbackMap = json.decode(storedData);
      return userFeedbackMap[userId] == true;
    } catch (e) {
      print('Error reading feedback data: $e');
      return false;
    }
  }

  /// Mark feedback dialog as shown for a specific user
  Future<void> markFeedbackDialogAsShown(String userId) async {
    final String? storedData = await _storageService.getFeedBack();
    Map<String, dynamic> userFeedbackMap = {};
    if (storedData != null) {
      try {
        userFeedbackMap = json.decode(storedData);
      } catch (e) {
        print('Error parsing stored data: $e');
      }
    }
    // Mark this user as having seen the feedback dialog
    userFeedbackMap[userId] = true;
    // Save back to SharedPreferences
    await _storageService.saveFeedBack(json.encode(userFeedbackMap));
  }

  /// Get the current user ID from SharedPreferences
  Future<String?> getCurrentUserId() async {
    // Use StorageService as the single source of truth for user id
    return await _storageService.getUserId();
  }



  /// Reset feedback dialog for a specific user (for testing)
  Future<void> resetFeedbackDialogForUser(String userId) async {
    final String? storedData = await _storageService.getFeedBack();

    if (storedData != null) {
      try {
        Map<String, dynamic> userFeedbackMap = json.decode(storedData);
        userFeedbackMap.remove(userId);
        await _storageService.saveFeedBack(
          json.encode(userFeedbackMap),
        );
      } catch (e) {
        print('Error resetting user feedback: $e');
      }
    }
  }

  /// Get all users who have seen the feedback dialog (for debugging)
  Future<List<String>> getUsersWhoHaveSeenFeedback() async {
    final String? storedData = await _storageService.getFeedBack();

    if (storedData == null) {
      return [];
    }

    try {
      Map<String, dynamic> userFeedbackMap = json.decode(storedData);
      return userFeedbackMap.keys
          .where((key) => userFeedbackMap[key] == true)
          .toList();
    } catch (e) {
      print('Error getting users list: $e');
      return [];
    }
  }
}
