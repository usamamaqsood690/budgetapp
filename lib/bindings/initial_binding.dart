/// Initial Binding - Initialize global services
///
/// This binding initializes all core services in the correct order:
/// 1. StorageService - Must be initialized first (handles local storage)
/// 2. TeamsWebhookService - Initialize early for error reporting
/// 3. ApiClient - Can be initialized independently (handles HTTP requests)
/// 4. AuthService - Depends on StorageService (manages authentication state)
///
/// All services are registered as permanent dependencies in GetX,
/// meaning they persist throughout the app lifecycle.
import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/core/services/storage_service.dart';
import 'package:wealthnxai/core/services/teams_webhook_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final storageServiceFuture = Get.putAsync<StorageService>(() async {
      final service = StorageService.instance;
      await service.init();
      return service;
    }, permanent: true);

    // 2. Initialize Teams Webhook Service for error reporting
    Get.putAsync<TeamsWebhookService>(() async {
      final service = TeamsWebhookService.instance;
      await service.initialize();
      return service;
    }, permanent: true);

    // 3. Initialize API Client (environment defaults to production)
    Get.putAsync<ApiClient>(() async {
      await storageServiceFuture;
      final client = ApiClient.instance;
      client.updateBaseUrl();
      return client;
    }, permanent: true);

    // 4. Initialize Auth Service after StorageService is ready
    Get.putAsync<AuthService>(() async {
      await storageServiceFuture;
      final service = AuthService.instance;
      await service.init();
      return service;
    }, permanent: true);
  }
}
