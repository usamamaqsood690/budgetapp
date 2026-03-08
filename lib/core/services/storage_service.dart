/// Storage Service - Singleton Pattern Implementation
/// Handles all local storage operations using SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  SharedPreferences? _prefs;
  StorageService._internal();

  // Authentication keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';
  // Session dialog flag key - controls whether session-expired dialog
  // should be shown on next unauthorized (401) response.
  static const String _sessionDialogAllowedKey = 'session_dialog_allowed';

  // User data keys
  static const String _emailKey = 'user_email';
  static const String _fullNameKey = 'user_full_name';
  static const String _phoneKey = 'user_phone';
  static const String _avatarKey = 'user_avatar';

  // Environment key
  static const String _environmentKey = 'app_environment';

  // Feedback Key
  static const String _feedbackShownKey = 'feedback_dialog_shown_users';
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _checkInitialization() {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
  }

  Future<bool> saveToken(String token) async {
    _checkInitialization();
    return await _prefs!.setString(_tokenKey, token);
  }

  /// Generic string setter so other services can reuse this storage layer
  Future<bool> saveFeedBack(String value) async {
    _checkInitialization();
    return await _prefs!.setString(_feedbackShownKey, value);
  }

  /// Generic string getter so other services can reuse this storage layer
  Future<String?> getFeedBack() async {
    _checkInitialization();
    return _prefs!.getString(_feedbackShownKey);
  }

  Future<String?> getToken() async {
    _checkInitialization();
    return _prefs!.getString(_tokenKey);
  }

  Future<bool> removeToken() async {
    _checkInitialization();
    return await _prefs!.remove(_tokenKey);
  }

  /// Session-expired dialog flag helpers
  ///
  /// When `true`, the app is allowed to show the "session expired" dialog
  /// on the next unauthorized (401) API response. Once the dialog is shown,
  /// this flag should be set to `false` so subsequent 401s in the same
  /// expired session do not trigger additional dialogs.
  ///
  /// On successful login, this flag should be reset to `true` so the
  /// next expired session can again show the dialog once.
  Future<bool> setSessionDialogAllowed(bool value) async {
    _checkInitialization();
    return await _prefs!.setBool(_sessionDialogAllowedKey, value);
  }

  Future<bool> isSessionDialogAllowed() async {
    _checkInitialization();
    return _prefs!.getBool(_sessionDialogAllowedKey) ?? false;
  }

  Future<bool> saveRefreshToken(String refreshToken) async {
    _checkInitialization();
    return await _prefs!.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    _checkInitialization();
    return _prefs!.getString(_refreshTokenKey);
  }

  Future<bool> removeRefreshToken() async {
    _checkInitialization();
    return await _prefs!.remove(_refreshTokenKey);
  }

  Future<bool> saveUserId(String userId) async {
    _checkInitialization();
    return await _prefs!.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    _checkInitialization();
    return _prefs!.getString(_userIdKey);
  }

  Future<bool> setLoggedIn(bool value) async {
    _checkInitialization();
    return await _prefs!.setBool(_isLoggedInKey, value);
  }

  bool isLoggedIn() {
    _checkInitialization();
    return _prefs!.getBool(_isLoggedInKey) ?? false;
  }

  Future<bool> removeFeedback() async {
    _checkInitialization();
    return await _prefs!.remove(_feedbackShownKey);
  }

  // User data methods
  Future<bool> saveUserEmail(String email) async {
    _checkInitialization();
    return await _prefs!.setString(_emailKey, email);
  }

  Future<String?> getUserEmail() async {
    _checkInitialization();
    return _prefs!.getString(_emailKey);
  }

  Future<bool> saveUserFullName(String fullName) async {
    _checkInitialization();
    return await _prefs!.setString(_fullNameKey, fullName);
  }

  Future<String?> getUserFullName() async {
    _checkInitialization();
    return _prefs!.getString(_fullNameKey);
  }

  Future<bool> saveUserPhone(String? phone) async {
    _checkInitialization();
    if (phone == null) {
      return await _prefs!.remove(_phoneKey);
    }
    return await _prefs!.setString(_phoneKey, phone);
  }

  Future<String?> getUserPhone() async {
    _checkInitialization();
    return _prefs!.getString(_phoneKey);
  }

  Future<bool> saveUserAvatar(String? avatar) async {
    _checkInitialization();
    if (avatar == null) {
      return await _prefs!.remove(_avatarKey);
    }
    return await _prefs!.setString(_avatarKey, avatar);
  }

  Future<String?> getUserAvatar() async {
    _checkInitialization();
    return _prefs!.getString(_avatarKey);
  }

  // Remove methods for user data
  Future<bool> removeUserId() async {
    _checkInitialization();
    return await _prefs!.remove(_userIdKey);
  }

  Future<bool> removeUserEmail() async {
    _checkInitialization();
    return await _prefs!.remove(_emailKey);
  }

  Future<bool> removeUserFullName() async {
    _checkInitialization();
    return await _prefs!.remove(_fullNameKey);
  }

  Future<bool> removeUserPhone() async {
    _checkInitialization();
    return await _prefs!.remove(_phoneKey);
  }

  Future<bool> removeUserAvatar() async {
    _checkInitialization();
    return await _prefs!.remove(_avatarKey);
  }

  /// Clear all authentication and user data
  /// This should be called on logout or password change
  Future<void> clearAllUserData() async {
    _checkInitialization();
    await removeToken();
    await removeRefreshToken();
    await removeUserId();
    await removeUserEmail();
    await removeUserFullName();
    await removeUserPhone();
    await removeUserAvatar();
    await setLoggedIn(false);
  }

  Future<void> logout() async {
    await clearAllUserData();
  }

  // Environment persistence methods
  Future<bool> saveEnvironment(String environment) async {
    _checkInitialization();
    return await _prefs!.setString(_environmentKey, environment);
  }

  Future<String?> getEnvironment() async {
    _checkInitialization();
    return _prefs!.getString(_environmentKey);
  }

  Future<bool> removeEnvironment() async {
    _checkInitialization();
    return await _prefs!.remove(_environmentKey);
  }
}
