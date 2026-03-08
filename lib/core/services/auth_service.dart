/// Auth Service - Singleton Pattern Implementation
/// Manages authentication state globally across the app
import 'package:get/get.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._internal();
    return _instance!;
  }

  final StorageService _storageService = StorageService.instance;
  final Rx<UserEntity?> _currentUser = Rx<UserEntity?>(null);
  final RxBool _isAuthenticated = false.obs;

  UserEntity? get currentUser => _currentUser.value;
  Stream<UserEntity?> get userStream => _currentUser.stream;

  AuthService._internal();

  Future<void> init() async {
    final isLoggedIn = _storageService.isLoggedIn();
    final token = await _storageService.getToken();

    if (isLoggedIn && token != null) {
      _isAuthenticated.value = true;
      await loadUserData();
    }
  }

  Future<void> setCurrentUser(UserEntity user) async {
    _currentUser.value = user;
    _isAuthenticated.value = true;
    await _storageService.setLoggedIn(true);
    await _storageService.saveUserId(user.id);
    await _storageService.saveUserEmail(user.email);
    await _storageService.saveUserFullName(user.name);
    // Allow session-expired dialog to show once for this new session
    await _storageService.setSessionDialogAllowed(true);
  }

  Future<String?> getToken() async {
    return await _storageService.getToken();
  }

  /// Load user data from local storage
  Future<void> loadUserData() async {
    final userId = await _storageService.getUserId();
    final email = await _storageService.getUserEmail();
    final fullName = await _storageService.getUserFullName();

    if (userId != null && email != null && fullName != null) {
      _currentUser.value = UserEntity(
        id: userId,
        email: email,
        name: fullName,
      );
    }
  }

  /// Check if user is logged in (replaces SessionManager.isLoggedIn)
  Future<bool> isLoggedIn() async {
    return _isAuthenticated.value && await isTokenValid();
  }

  /// Logout and clear all user data and session
  Future<void> logout() async {
    _currentUser.value = null;
    _isAuthenticated.value = false;
    await _storageService.logout();
  }

  Future<bool> isTokenValid() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> checkSession() async {
    try {
      Get.find<StorageService>();
    } catch (e) {
      await _storageService.init();
    }
    await _storageService.init();
    await init();
    return await isLoggedIn();
  }
}
